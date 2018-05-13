class UsersController < ApplicationController
  before_action :set_user
  layout "profile"

  def show
    @pods = @user.pods.newest.page(params[:page])
    @pod = Pod.new
  end

  private

    def set_user
      username = params[:user_username] || params[:username]

      if current_user.present? && username == current_user.username
        @user = current_user
      else
        @user = User.find_by!(username: username)
      end
    end
end
