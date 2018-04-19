class User::AvatarsController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.avatar.attach(params[:avatar])

    respond_to do |format|
      format.html { redirect_to edit_user_registration_path }
      format.js
    end
  end
end
