class HomeController < ApplicationController
  layout "home"

  def index
    @stories = Story.includes(:user).all
  end
end
