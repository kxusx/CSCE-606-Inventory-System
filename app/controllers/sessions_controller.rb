class SessionsController < Devise::SessionsController
  before_action :redirect_if_authenticated, only: [:new]

  def new
    super
  end

  def create
    super
  end

  def destroy
    sign_out(current_user) # Devise method to log out
    redirect_to new_user_session_path, notice: "Logged out successfully"
  end

  private

  # Prevent already logged-in users from accessing login/signup pages
  def redirect_if_authenticated
    if user_signed_in?
      redirect_to dashboard_path, alert: "You are already signed in."
    end
  end
end
