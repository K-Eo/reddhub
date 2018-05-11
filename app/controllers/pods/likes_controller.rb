class Pods::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pod

  def create
    @pod.liked_by(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(current_user.username)) }
      format.js
    end
  end

  def destroy
    @pod.unliked_by(current_user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(current_user.username)) }
      format.js
    end
  end

  private

    def set_pod
      @pod = Pod.find(params[:pod_id])
    end
end
