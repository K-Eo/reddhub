class User::AvatarsController < ApplicationController
  def update
    current_user.avatar.attach(params[:avatar])

    respond_to do |format|
      format.html { redirect_to edit_user_registration_path }
    end
  end
end
