class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.react(@reactable, params[:name])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.unreact(@reactable)
    redirect_back(fallback_location: root_path)
  end
end
