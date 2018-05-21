class Profiles::FollowersController < ApplicationController
  before_action :set_user_by_username
  layout "profile"

  def show
    @followers = @user.followers.with_attached_avatar.page(params[:page])
  end
end
