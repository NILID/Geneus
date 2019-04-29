module ApplicationHelper

  # show value if exist
  # or text EMPTY with css class equal text-muted
  def show_or_empty(value)
    value.blank? ? content_tag(:span, 'Empty', class: 'text-muted') : value
  end
end
