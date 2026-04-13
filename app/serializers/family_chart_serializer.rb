class FamilyChartSerializer
  def initialize(people = Person.all)
    @people = people
  end

  def nodes
    @nodes ||= @people.map(&:family_chart_node)
  end

  # Optional edge list useful for debugging integrations.
  def connectors
    @connectors ||= begin
      edges = []

      nodes.each do |node|
        source = node[:id]
        rels = node[:rels] || {}

        Array(rels[:parents]).each do |target|
          edges << { from: source, to: target, type: 'parent' }
        end
        Array(rels[:spouses]).each do |target|
          edges << { from: source, to: target, type: 'spouse' }
        end
        Array(rels[:children]).each do |target|
          edges << { from: source, to: target, type: 'child' }
        end
      end

      edges.uniq
    end
  end
end
