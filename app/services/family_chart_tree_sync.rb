require 'set'

# Synchronizes family-chart exportData() / onChange payloads with Person, Parentship, and Partnership.
# Payload shape matches family-chart Datum[]: id, data (gender M/F, fields...), rels (parents, spouses, children).
class FamilyChartTreeSync
  class Error < StandardError; end

  attr_reader :errors

  def initialize(nodes:, removed_ids: [])
    @raw_nodes = Array(nodes)
    @removed_ids = Array(removed_ids).map(&:to_s).uniq
    @errors = []
    @id_map = {} # external_id (string) => Person
  end

  def call
    validate_payload!
    preload_referenced_people!
    ActiveRecord::Base.transaction do
      upsert_people!
      sync_parentships!
      sync_partnerships!
      destroy_removed!
    end
    self
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    raise Error, e.message
  end

  def success?
    @errors.empty?
  end

  private

  def validate_payload!
    seen = {}
    @raw_nodes.each do |node|
      node = normalize_node(node)
      id = node['id'].to_s
      raise Error, 'Each node must have an id' if id.blank?
      raise Error, "Duplicate node id #{id}" if seen[id]

      seen[id] = true
    end
  end

  # Allows partial payloads: relationship ids can point at existing DB rows not listed in this request.
  def preload_referenced_people!
    in_payload = @raw_nodes.map { |n| normalize_node(n)['id'].to_s }.to_set
    referenced = Set.new
    @raw_nodes.each { |raw| referenced.merge(rel_refs(normalize_node(raw))) }

    (referenced - in_payload).each do |rid|
      person = find_person_by_external_id(rid)
      @id_map[rid] = person if person
    end
  end

  def normalize_node(node)
    h = node.respond_to?(:to_unsafe_h) ? node.to_unsafe_h : node.to_h
    h = h.stringify_keys
    h['rels'] = (h['rels'] || {}).stringify_keys
    h['data'] = (h['data'] || {}).stringify_keys
    h
  end

  def rel_refs(node)
    rels = node['rels'] || {}
    ids = []
    ids += Array(rels['parents']).map(&:to_s)
    ids += Array(rels['spouses']).map(&:to_s)
    ids += Array(rels['children']).map(&:to_s)
    ids << rels['father'].to_s if rels['father'].present?
    ids << rels['mother'].to_s if rels['mother'].present?
    ids.reject(&:blank?).uniq
  end

  def upsert_people!
    @raw_nodes.each do |raw|
      node = normalize_node(raw)
      next if truthy?(node['unknown'])

      ext_id = node['id'].to_s
      person = @id_map[ext_id] || find_person_by_external_id(ext_id)
      attrs = attributes_from_chart_data(node['data'] || {})

      if person
        person.update!(attrs) if attrs.any?
      else
        if numeric_ext_id?(ext_id)
          raise Error, "Unknown person id #{ext_id}"
        end

        person = Person.new(attrs.merge(chart_id: ext_id).compact)
        person.save!
      end

      @id_map[ext_id] = person
    end
  end

  def sync_parentships!
    @raw_nodes.each do |raw|
      node = normalize_node(raw)
      next if truthy?(node['unknown'])

      ext_id = node['id'].to_s
      child = @id_map[ext_id]
      raise Error, "Missing person for #{ext_id}" unless child

      rels = node['rels'] || {}
      parent_ids = parent_ids_from_rels(rels)

      father_id, mother_id = assign_father_mother_slots(parent_ids)

      ps = child.parentship || child.build_parentship
      ps.update!(father_id: father_id, mother_id: mother_id)
    end
  end

  def parent_ids_from_rels(rels)
    rels = rels.stringify_keys
    ids = Array(rels['parents']).map(&:to_s)
    ids << rels['father'].to_s if rels['father'].present?
    ids << rels['mother'].to_s if rels['mother'].present?
    ids.reject(&:blank?).uniq
  end

  # Mirrors family-chart legacy export: first M fills father slot, second M fills mother slot;
  # first F fills mother slot, second F fills father slot.
  def assign_father_mother_slots(parent_ext_ids)
    father_id = nil
    mother_id = nil

    parent_ext_ids.each do |pid|
      p = @id_map[pid.to_s] || find_person_by_external_id(pid.to_s)
      next unless p

      if p.gender == 'male'
        if father_id.nil?
          father_id = p.id
        elsif mother_id.nil?
          mother_id = p.id
        end
      elsif p.gender == 'female'
        if mother_id.nil?
          mother_id = p.id
        elsif father_id.nil?
          father_id = p.id
        end
      end
    end

    [father_id, mother_id]
  end

  def sync_partnerships!
    @raw_nodes.each do |raw|
      node = normalize_node(raw)
      next if truthy?(node['unknown'])

      ext_id = node['id'].to_s
      person = @id_map[ext_id]
      next unless person

      rels = node['rels'] || {}
      desired_partner_ids = Array(rels['spouses']).map(&:to_s).filter_map do |sid|
        (@id_map[sid] || find_person_by_external_id(sid))&.id
      end.uniq

      current_ids = person.partner_ids
      (current_ids - desired_partner_ids).each do |pid|
        person.partnerships.where(partner_id: pid).destroy_all
      end

      (desired_partner_ids - current_ids).each do |pid|
        next if pid == person.id

        person.partnerships.create!(partner_id: pid) unless person.partnerships.exists?(partner_id: pid)
      end
    end
  end

  def destroy_removed!
    @removed_ids.each do |ext_id|
      person = find_person_by_external_id(ext_id)
      next unless person

      Parentship.where(father_id: person.id).update_all(father_id: nil)
      Parentship.where(mother_id: person.id).update_all(mother_id: nil)
      person.destroy!
    end
  end

  def find_person_by_external_id(ext_id)
    ext_id = ext_id.to_s
    if numeric_ext_id?(ext_id)
      Person.find_by(id: ext_id.to_i)
    else
      Person.find_by(chart_id: ext_id)
    end
  end

  def numeric_ext_id?(ext_id)
    ext_id.match?(/\A\d+\z/)
  end

  def attributes_from_chart_data(data)
    data = data.stringify_keys
    gender = data['gender'].to_s.upcase == 'F' ? 'female' : 'male'

    fn = data['first name'].to_s.strip
    ln = data['last name'].to_s.strip
    combined = [fn, ln].reject(&:blank?).join(' ').presence
    name = combined.presence || data['name'].presence || 'Unknown'

    {
      name: name,
      gender: gender,
      date_of_birth: parse_date(data['birthday']),
      date_of_death: parse_date(data['death']),
      bio: data['bio'].presence
    }.compact
  end

  def parse_date(value)
    return nil if value.blank?

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end

  def truthy?(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
