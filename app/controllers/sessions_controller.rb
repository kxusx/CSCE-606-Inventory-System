class SessionsController < Devise::SessionsController
  before_action :redirect_if_authenticated, only: [:new]
  skip_before_action :require_no_authentication, only: [:new]

  def new
    super
  end

  def create
    #puts params.inspect
    user = User.find_by(email: params[:user][:email]) # Ensure correct parameter format

    if user && user.valid_password?(params[:user][:password]) # Devise method to check password
      sign_in(:user, user) # ✅ Fix: Specify the scope
      #sign_in(user)
      # Retrieve the stored location BEFORE redirecting
      redirect_to after_sign_in_path_for(user), notice: "Signed in successfully!"
    else
      flash.now[:alert] = "Invalid Email or password."
      self.resource = User.new # ✅ Ensure the form reloads with a valid resource
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user)# Devise method to log out
    reset_session  # ✅ Clears all session data (including stored locations)
    redirect_to new_user_session_path, notice: "Logged out successfully"
  end

  private

  # Prevent already logged-in users from accessing login/signup pages
  def redirect_if_authenticated
    if user_signed_in? 
      flash[:console_alert] = "You are already signed in."
      flash.keep(:console_alert)
      redirect_to dashboard_path
    end
  end

end
