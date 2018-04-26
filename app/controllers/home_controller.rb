class HomeController < ApplicationController
  layout "home"

  def index
    @stories = StoryPolicy::Home.new(current_user, Story).resolve
  end
end
