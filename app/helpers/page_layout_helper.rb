module PageLayoutHelper
  def page_layout(option = nil)
    if option
      @page_layout = option
    else
      @page_layout
    end
  end

  def profile_nav(option = nil)
    if option.nil?
      @profile_nav
    else
      @profile_nav = option
    end
  end

  def page_footer(option = nil)
    if option.nil?
      @page_footer
    else
      @page_footer = option
    end
  end

  def body_classes(classes = nil)
    @body_classes ||= ""

    if classes.nil?
      @body_classes
    else
      @body_classes = classes
    end
  end

  def page_classes(classes = nil)
    classes ||= ""
    classes.split(" ").push(controller_name, action_name).join(" ")
  end
end
