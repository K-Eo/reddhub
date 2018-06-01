class Me::CoversController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActionController::ParameterMissing do
    redirect_to edit_user_registration_path, alert: t(".missing")
  end

  def create
    @cover = Cover.new(cover_params)

    if @cover.attach(current_user)
      redirect_to edit_user_registration_path, notice: t(".notice")
    else
      redirect_to edit_user_registration_path, notice: t(".alert")
    end
  end

  private

    def cover_params
      params.require(:cover).permit(:image)
    end
end
