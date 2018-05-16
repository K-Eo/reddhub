class HomeController < ApplicationController
  before_action :authenticate_user!
  layout "home"

  def show
    @user = current_user
    @pods = current_user.feed.page(params[:page])
    @pod = Pod.new
  end
end
