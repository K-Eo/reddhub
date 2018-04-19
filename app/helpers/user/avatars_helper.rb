module User::AvatarsHelper
  def user_avatar(user, options = nil)
    options ||= {}
    html = options.delete(:html) || {}

    if user.avatar.attached?
      src = user.avatar.variant(options)
    else
      src = "https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04?s=256&d=mm"
    end

    image_tag(src, html)
  end

  def current_user_avatar(options = nil)
    user_avatar(current_user, options)
  end
end
