class Profiles::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_by_username

  def create
    current_user.follow(@user)
    redirect_to(user_profile_path(@user.username), notice: t(".notice", username: @user.username))
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to(user_profile_path(@user.username), notice: t(".notice", username: @user.username))
  end
end
