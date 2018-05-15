class HomeController < ApplicationController
  layout "home"
  helper_method :resource_name, :resource, :resource_class, :devise_mapping

  def index
    @stories = Story.order(created_at: :desc).published.page(params[:page])
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
