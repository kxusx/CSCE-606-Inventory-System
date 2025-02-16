class SessionsController < Devise::SessionsController
  before_action :redirect_if_authenticated, only: [:new]

  def new
    super
  end

  def create
    user = User.find_by(email: params[:email]) # Ensure correct parameter format

    if user && user.valid_password?(params[:password]) # Devise method to check password
      sign_in(user)
      redirect_to dashboard_path, notice: "Logged in successfully!"
    else
      flash.now[:alert] = "Invalid Email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)# Devise method to log out
    redirect_to new_user_session_path, notice: "Logged out successfully"
  end

  private

  # Prevent already logged-in users from accessing login/signup pages
  def redirect_if_authenticated
    if user_signed_in? && request.path != dashboard_path
      redirect_to dashboard_path, alert: "You are already signed in."
    end
  end
end
