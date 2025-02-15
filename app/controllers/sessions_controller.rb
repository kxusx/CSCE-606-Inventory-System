class SessionsController < ApplicationController
  def new
    # Just render the login form (new.html.erb)
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      # Retrieve the stored location BEFORE redirecting
      redirect_path = get_stored_location || dashboard_path


      redirect_to redirect_path, notice: "Logged in successfully"
      # Redirect to the stored location (or dashboard if none)
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully"
  end
end
