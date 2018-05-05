class UsersController < ApplicationController
  def show
    if params[:username] == current_user.username
      @user = current_user
    else
      @user = User.find_by(username: params[:username])
    end
  end
end
