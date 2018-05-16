class HomeController < ApplicationController
  before_action :authenticate_user!
  layout "home"

  def show
    @user = current_user
  end
end
