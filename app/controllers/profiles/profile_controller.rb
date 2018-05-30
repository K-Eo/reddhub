class Profiles::ProfileController < ApplicationController
  before_action :set_user_by_username
  layout "profile"

  def show
    @pods = @user.pods.newest.page(params[:page])
    @reactions = current_user.reactions_for(@pods, "Pod")
  end
end
