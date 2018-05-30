class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404
  end

  def current_user
    super || guest_user
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

    def set_locale
      logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
      logger.debug "* Locale set to '#{I18n.locale}'"
    end

    def guest_user
      @guest ||= Guest.new
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

    def set_user_by_username
      username = params[:username]

      if !current_user.guest? && username == current_user.username
        @user = current_user
      else
        @user = User.find_by!(username: username)
      end
    end
end
