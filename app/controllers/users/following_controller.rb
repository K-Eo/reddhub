class Users::FollowingController < UsersController
  before_action :set_user
  layout "profile"

  def show
    @following = @user.following.with_attached_avatar.page(params[:page])
  end
end
