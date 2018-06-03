class Finders::UsersController < ApplicationController
  before_action :authenticate_user!
  layout "finder"

  def index
    if params[:q].present?
      @users = User.with_attached_avatar
        .username_finder(params[:q])
        .page(params[:page])
    else
      @users = nil
    end
  end
end
