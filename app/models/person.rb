class Person < ApplicationRecord
  include Tokenable
  after_create :create_parentship

  has_one_attached :avatar
  has_paper_trail

  has_many :partnerships, :dependent => :destroy
  has_many :partners, through: :partnerships, :source => :partner
  has_many :defacto_partners, through: :partnerships, :source => :partner#, :finder_sql =>
 
  has_one :parentship, dependent: :destroy
  has_one :mother, through: :parentship, source: :father
  has_one :father, through: :parentship, source: :mother

  has_many :children_of_father, class_name: 'Parentship', :foreign_key => 'father_id'
  has_many :children_of_mother, class_name: 'Parentship', :foreign_key => 'mother_id'

  has_many :notes, :dependent => :destroy

  accepts_nested_attributes_for :parentship

  scope :men,   -> { where(gender: 'male') }
  scope :women, -> { where(gender: 'female') }

  # named_scope :parents, { :include => [ :mother, :father ] }

  validates_length_of :name,
    minimum: 1
  validates :chart_id, uniqueness: { allow_blank: true }
  validates_inclusion_of :gender,
    in: %w( male female ),
    message: 'must be specified'
  validates_date :date_of_birth, {
    :on_or_before => :today,
    :on_or_before_message => 'must be before today',
    :allow_blank => true
  }
  validates_date :date_of_birth, {
    :on_or_before => :date_of_death,
    :on_or_before_message => 'must be before date of death',
    :allow_blank => true
  }
  validates_date :date_of_death, {
    :on_or_before => :today,
    :on_or_before_message => 'must be before today',
    :on_or_after => :date_of_birth,
    :on_or_after_message => 'must be after date of birth',
    :allow_blank => true
  }

  def children
    Person
      .joins(:parentship)
      .where(parentships: { father_id: id })
      .or(Person.joins(:parentship).where(parentships: { mother_id: id }))
      .distinct
      .order(:date_of_birth)
  end

  def children_ids
    children.pluck(:id)
  end

  def children_with(partner)
    return [] unless partner

    Person
      .joins(:parentship)
      .where(parentships: { father_id: id, mother_id: partner.id })
      .or(Person.joins(:parentship).where(parentships: { father_id: partner.id, mother_id: id }))
      .distinct
  end

  def add_child( child )
    raise ArgumentError, "Child must be a Person" unless child.is_a?(Person)

    if gender == 'male'
      children_as_father.find_or_create_by(child: child)
    elsif gender == 'female'
      children_as_mother.find_or_create_by(child: child)
    else
      errors.add(:base, "Cannot determine person's gender.")
      false
    end
  end

  def remove_child( child )
    raise ArgumentError, "Child must be a Person" unless child.is_a?(Person)

    association = gender == 'male' ? children_as_father : gender == 'female' ? children_as_mother : nil

    if association
      link = association.find_by(child: child)
      link&.destroy
    else
      errors.add(:base, "Cannot determine person's gender.")
      false
    end
  end

  def all_partners
    # TODO: добавить defacto-партнёров по необходимости (через детей)
    partners.order('partnerships.date_started')
  end

  def parents
    [mother, father].compact
  end

  def chart_external_id
    chart_id.presence || id.to_s
  end

  def family_chart_node
    {
      id: chart_external_id,
      data: family_chart_data,
      rels: family_chart_relationships
    }
  end

  def family_chart_relationships
    relationships = {}

    parent_ids = parents.map(&:chart_external_id)
    spouse_ids = partners.distinct.map(&:chart_external_id)
    child_ids = children.distinct.map(&:chart_external_id)

    relationships[:parents] = parent_ids unless parent_ids.empty?
    relationships[:spouses] = spouse_ids unless spouse_ids.empty?
    relationships[:children] = child_ids unless child_ids.empty?

    relationships
  end

  # === Данные для графа семьи — вынести в отдельный класс в будущем ===
  def family_chart_data
    {
      'first name' => first_name,
      'last name' => last_name,
      'name' => name,
      'gender' => family_chart_gender,
      'birthday' => date_of_birth&.iso8601,
      'death' => date_of_death&.iso8601
    }.compact
  end

  def family_chart_gender
    gender == 'female' ? 'F' : 'M'
  end

  def first_name
    name.to_s.strip.split.first
  end

  def last_name
    parts = name.to_s.strip.split
    parts.length > 1 ? parts[1..].join(' ') : nil
  end

  # === Генерация JSON для дерева — ВАЖНО: вынести в отдельный сервис! ===
  def ancestry_json
    person_data = attributes.except('created_at', 'updated_at').merge(
      'children' => [],
      'data' => { '$orn' => 'center' }
    )

    # Дети
    (children_as_father + children_as_mother).uniq.each do |child_ps|
      child = child_ps.child
      person_data['children'] << child.attributes.except('created_at', 'updated_at').merge(
        'data' => { '$orn' => 'top' },
        'children' => []
      )
    end

    # Партнёры
    partnerships.includes(partner: [:parentship]).each do |ps|
      partner = ps.partner
      next unless partner

      person_data['children'] << partner.attributes.except('created_at', 'updated_at').merge(
        'data' => { '$orn' => 'left' },
        'children' => []
      )
    end

    # Родители и предки
    parents.each do |parent|
      parent_data = parent.attributes.except('created_at', 'updated_at').merge(
        'data' => { '$orn' => 'bottom' },
        'children' => []
      )

      # Бабушки/дедушки
      parent.parents.each do |grandparent|
        grandparent_data = grandparent.attributes.except('created_at', 'updated_at').merge(
          'data' => { '$orn' => 'bottom' },
          'children' => []
        )

        # Прабабушки/прадедушки
        grandparent.parents.each do |great_grandparent|
          ggp_data = great_grandparent.attributes.except('created_at', 'updated_at').merge(
            'data' => { '$orn' => 'bottom' }
          )
          grandparent_data['children'] << ggp_data
        end

        parent_data['children'] << grandparent_data
      end

      person_data['children'] << parent_data
    end

    person_data.to_json
  end

  private

  def create_parentship
    Parentship.find_or_create_by(person: self) if gender.present?
  end
end
