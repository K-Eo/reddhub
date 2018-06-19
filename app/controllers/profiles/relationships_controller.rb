class Profiles::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_by_username

  rescue_from ActiveRecord::RecordNotUnique do
    redirect_to(user_profile_path(@user.username), notice: t(".already", username: @user.username))
  end

  rescue_from Reddhub::Relationship::SameUser do
    redirect_to(user_profile_path(@user.username), notice: t(".same"))
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to(user_profile_path(current_user.username), notice: t(".missing", username: params[:username]))
  end

  def create
    current_user.follow(@user)
    redirect_to(user_profile_path(@user.username), notice: t(".notice", username: @user.username))
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to(user_profile_path(@user.username), notice: t(".notice", username: @user.username))
  end
end
