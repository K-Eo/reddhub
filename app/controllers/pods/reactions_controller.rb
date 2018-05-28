class Pods::ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pod

  def destroy
    @pod.reactions.where(user: current_user).destroy_all
    redirect_back(fallback_location: root_path)
  end

  def create
    @pod.reactions
      .where(user: current_user, name: sanitize_emoji_name)
      .first_or_create
    redirect_back(fallback_location: root_path)
  end

  private

    def sanitize_emoji_name
      if Reaction::NAMES.include?(params[:name])
        params[:name]
      else
        Reaction::DEFAULT_NAME
      end
    end

    def set_pod
      @pod = Pod.find(params[:pod_id])
    end
end
