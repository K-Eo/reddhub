class Profiles::FollowingController < ApplicationController
  before_action :set_user_by_username
  layout "profile"

  def show
    @following = @user.following.with_attached_avatar.page(params[:page])
  end
end
