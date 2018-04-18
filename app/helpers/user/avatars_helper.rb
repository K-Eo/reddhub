module User::AvatarsHelper
  def get_user_avatar(user = nil)
    user = user || current_user
    if user.avatar.attached?
      user.avatar
    else
      "https://www.gravatar.com/avatar/1da67f9c292299c7512d9f0dc2c13f04?s=256&d=mm"
    end
  end
end
