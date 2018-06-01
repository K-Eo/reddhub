module StateHelper
  def create_empty_state(title, subtitle, icon, icon_type = "fas")
    content_tag :div, class: "empty-state" do
      concat icon(icon_type, icon)
      concat content_tag :h3, title, class: "font-weight-bold mt-4 mb-0"
      concat content_tag :p, subtitle, class: "text-secondary lead"
    end
  end
end
