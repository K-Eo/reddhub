module User::AvatarsHelper
  def get_user_avatar(user)
    user.avatar.attached? ? user.avatar : "https://placehold.it/256"
  end
end
