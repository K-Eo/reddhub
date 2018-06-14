class Me::AvatarsController < ApplicationController
  before_action :authenticate_user!

  def create
    @avatar = Avatar.new(avatar_params)

    if @avatar.attach(current_user)
      redirect_to edit_me_avatar_path, notice: t(".notice")
    else
      redirect_to edit_user_registration_path, alert: t(".alert")
    end
  end

  def edit
    unless current_user.original.attached?
      redirect_to edit_user_registration_path, alert: t(".alert")
    end
  end

  def update
    current_user.avatar.attach(avatar_params[:image])

    if current_user.avatar.attached?
      redirect_to edit_user_registration_path, notice: t(".notice")
    else
      redirect_to edit_user_registration_path, alert: t(".alert")
    end
  end

  private

    def avatar_params
      params.require(:avatar).permit(:image)
    end
end
