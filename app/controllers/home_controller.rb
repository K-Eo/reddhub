class HomeController < ApplicationController
  layout "home"

  def index
    @stories = Story.order(created_at: :desc).published.page(params[:page])
  end
end
