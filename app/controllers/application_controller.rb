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
