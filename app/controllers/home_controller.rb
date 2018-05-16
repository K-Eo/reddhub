class HomeController < ApplicationController
  before_action :authenticate_user!
  layout "profile"

  def show
    @user = current_user
  end
end
