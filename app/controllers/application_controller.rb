class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:new, :create]
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  protected

  # Ensure Devise allows additional parameters like name
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
  # method use in dashboard_controller for login
  def require_login
    unless current_user
      store_location # Save URL before redirecting
      redirect_to login_path, alert: "You must logged in to access this page"
    end
  end

  private

  # Store the original URL before redirecting to login
  def store_location
    session[:return_to] = request.fullpath if request.get? && !request.xhr?
  end

  # Retrieve the stored location or return nil
  def get_stored_location
    return_to = session[:return_to]
    session.delete(:return_to) # Clear stored location AFTER retrieving it
      # Check if the stored location is a bin page and if the user owns that bin
    if return_to&.match?(%r{^/bins/(\d+)$})
      bin_id = return_to.match(%r{^/bins/(\d+)$})[1].to_i
      bin = Bin.find_by(id: bin_id)
      # If the bin exists and belongs to the logged-in user, allow redirection
      return return_to if bin && bin.user_id == session[:user_id]
    end
    dashboard_path # go to dashboard path of the other user if this bin doesnt belong to him
  end


end

