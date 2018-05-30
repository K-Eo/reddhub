class Profiles::ProfileController < ApplicationController
  before_action :set_user_by_username
  layout "profile"

  def show
    @pods = @user.pods.newest.page(params[:page])
    @votes = current_user.guest? ? [] : current_user.reactions_for(@pods.map(&:id), "Pod")
    @pod = Pod.new
  end
end
