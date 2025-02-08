class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  #Needs to know the current user to access to dashboar
  helper_method :current_user # available to views

  #now, let's check if session[:user_id] exist (if user is logged in), tore the result in @current_user
  # use memoization for better performance
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # method use in dashboard_controller for login
  def require_login
    unless current_user
      redirect_to login_path, alert: "You must logged in to access this page"
    end
  end
end
