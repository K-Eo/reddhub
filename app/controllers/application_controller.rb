class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404
  end

  private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end

    def render_404
      respond_to do |format|
        format.html do
          render file: Rails.root.join("public", "404"), layout: false, status: "404"
        end

        format.js { render json: "", status: :not_found, content_type: "application/json" }
        format.any { head :not_found }
      end
    end

  protected

    def configure_permitted_parameters
      added_attrs = [
        :email,
        :name,
        :password,
        :password_confirmation,
        :remember_me,
        :username
      ]

      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
end
