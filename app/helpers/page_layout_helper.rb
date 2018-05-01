module PageLayoutHelper
  def page_raw(option = nil)
    @page_raw ||= false

    if option.nil?
      @page_raw
    else
      @page_raw = option
    end
  end

  def page_footer(option = nil)
    @page_footer ||= false

    if option.nil?
      @page_footer
    else
      @page_footer = option
    end
  end

  def page_classes(classes = nil)
    classes ||= ""
    classes.split(" ").push(controller_name, action_name).join(" ")
  end
end
