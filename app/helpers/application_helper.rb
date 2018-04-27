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
end
