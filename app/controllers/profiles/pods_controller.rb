class Profiles::PodsController < ApplicationController
  before_action :set_user_by_username
  layout "home"

  def show
    @pod = @user.pods.find(params[:id])
    @votes = current_user.nil? ? [] : current_user.reactions_for([@pod.id], "Pod")
  end
end
