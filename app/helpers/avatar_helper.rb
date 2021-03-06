module AvatarHelper
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

  def avatar_url(user, options = nil)
    if user.avatar.attached? && options.present?
      user.avatar.variant(options)
    elsif user.avatar.attached?
      user.avatar
    else
      "https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04?s=256&d=mm"
    end
  end
end
