class Profiles::ProfileController < ApplicationController
  before_action :set_user_by_username
  layout "profile"

  def show
    @pods = @user.pods.newest.page(params[:page])
    @votes = user_signed_in? ? current_user.reactions_for(@pods.map(&:id), "Pod") : []
    @pod = Pod.new
  end
end
