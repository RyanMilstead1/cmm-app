module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new({})
    markdown = Redcarpet::Markdown.new(renderer, {})
    markdown.render(text).html_safe
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'success' then 'alert alert-success'
    when 'error' then 'alert alert-danger'
    when 'alert' then 'alert alert-danger'
    end
  end
end
