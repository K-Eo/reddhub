class UsersController < ApplicationController
  def show
    if current_user.present? && params[:username] == current_user.username
      @user = current_user
    else
      @user = User.find_by!(username: params[:username])
    end

    @pods = Pod.order(created_at: :desc).page(params[:page])
    @pod = Pod.new
  end
end
