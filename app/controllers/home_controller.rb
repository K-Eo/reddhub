class HomeController < ApplicationController
  before_action :authenticate_user!
  layout "home"

  def show
    @user = current_user
    @pods = current_user.feed.with_attached_images.page(params[:page])
    @reactions = current_user.reactions_for(@pods, "Pod")
    @pod = Pod.new
  end
end
