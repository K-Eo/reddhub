class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @reaction = current_user.react(@reactable, params[:name])

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    current_user.unreact(@reactable)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end
end
