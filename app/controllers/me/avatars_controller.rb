class Me::AvatarsController < ApplicationController
  before_action :authenticate_user!

  def create
    @avatar = Avatar.new(avatar_params)

    if @avatar.attach(current_user)
      redirect_to edit_me_avatar_path
    else
      redirect_to edit_user_registration_path, alert: "Snaps! Something went wrong, try again."
    end
  end

  def edit
  end

  def update
    current_user.avatar.attach(avatar_params[:image])
    redirect_to edit_user_registration_path, notice: "Avatar saved"
  end

  private

    def avatar_params
      params.require(:avatar).permit(:image)
    end
end
