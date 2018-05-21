class Profiles::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_by_username

  def create
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_to(user_profile_path(@user.username)) }
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to(user_profile_path(@user.username)) }
      format.js
    end
  end
end
