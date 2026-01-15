module ApplicationHelper
  def field_errors(object, field)
    return if object.errors[field].empty?

    content_tag :div, class: "error" do
      object.errors[field].join(', ')
    end
  end
end
