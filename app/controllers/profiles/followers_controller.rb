class Profiles::FollowersController < UsersController
  before_action :set_user
  layout "profile"

  def show
    @followers = @user.followers.with_attached_avatar.page(params[:page])
  end
end
