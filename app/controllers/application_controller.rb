class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Redirect user to dashboard after login
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Redirect user to login page after logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected

  # Ensure Devise allows additional parameters like name
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

