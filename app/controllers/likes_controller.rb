class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @likeable.liked_by(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: user_profile_path(current_user.username)) }
      format.js
    end
  end

  def destroy
    @likeable.unliked_by(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: user_profile_path(current_user.username)) }
      format.js
    end
  end
end
