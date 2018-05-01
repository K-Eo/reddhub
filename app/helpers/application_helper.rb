module ApplicationHelper
  def active_when(condition, additional_classes = nil)
    additional_classes ||= ""

    if condition
      additional_classes = additional_classes
        .split(" ")
        .push("active")
        .join(" ")
    end

    additional_classes
  end

  def markdown(content)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true,
                                           filter_html: true,
                                           safe_links_only: true,
                                           escape_html: true)

    options = {
      fenced_code_blocks: true,
      autolink: true,
      space_after_headers: true
    }

    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end
end
