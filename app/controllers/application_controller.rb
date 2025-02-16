class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:new]

  # Ensure only modern browsers are supported (remove if unnecessary)
  # allow_browser versions: :modern 

  # Redirect user to dashboard after login
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Ensures logout redirects to login page
  end
end
