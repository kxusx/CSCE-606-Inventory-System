class UsersController < ApplicationController
  def new
    @user = User.new  # Initialize a new User object
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to dashboard_path, notice: "Account created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
