module PeopleHelper
  def tree_node(person, active: false)
    render partial: 'tree_node', locals: { person: person, active: active }
  end

  def children_with(partner)
    unless partner.nil?
      children_html = []
      @person.children_with(partner).each do |child|
        children_html.push tree_node(child)
      end
      unless children_html.empty?
        separator_html = '<div class="node_separator"></div>'
        concat (separator_html + children_html.join(separator_html)).html_safe
      end
    end
    nil
  end

  def avatar_or_default(person)
    person.avatar.attached? ? person.avatar : "missing_#{person.gender}.png"
  end
end
