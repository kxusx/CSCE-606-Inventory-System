class PasswordController < ApplicationController
    skip_before_action :authenticate_user!, only: [
    :forgot, 
    :send_reset_code, 
    :reset_code, 
    :verify_reset_code, 
    :resend_reset_code, 
    :reset, 
    :update
    ]

    require 'securerandom'
    def new
        super
    end

    def create
        super
    end

    def forgot
      render 'password/forgot'
    end
  
    def send_reset_code
      @user = User.find_by(email: params[:email])
      if @user
        @user.update(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)
    
        # Send email
        UserMailer.reset_password_email(@user).deliver_now

        flash[:notice] = "Reset code sent to your email."
        redirect_to reset_code_path
      else
        flash[:error] = "User not registered in the database"
        redirect_to forgot_password_path 
      end
    end
  
    def reset_code
      render 'password/reset_code'
    end
  
    def verify_reset_code
      if current_reset_user&.reset_sent_at&.>(15.minutes.ago) && current_reset_user&.reset_code == params[:reset_code]
        session[:reset_user_id] = current_reset_user.id
        redirect_to new_password_reset_path
      else
        flash[:error] = "Invalid or expired reset code"
        redirect_to reset_code_path
      end
    end
  
    def resend_reset_code
      if current_reset_user
        current_reset_user.update(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)

        # Send email again
        UserMailer.reset_password_email(@user).deliver_now

        flash[:success] = "New reset code sent to your email."
        redirect_to reset_code_path
      else
        flash[:error] = "Session expired. Please request a new reset code."
        redirect_to forgot_password_path
      end
    end
  
    def reset
      render 'password/reset'
    end
  
    def update
      if current_reset_user && params[:password].match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/)
        current_reset_user.update(password: params[:password], reset_code: nil)
        session[:reset_user_id] = nil
        flash[:success] = "Password reset successful!"
        redirect_to new_user_session_path
      else
        flash[:error] = "Password format incorrect!"
        redirect_to new_password_reset_path
      end
    end
  
    private
  
    def current_reset_user
      @current_reset_user ||= User.find_by(id: session[:reset_user_id])
    end
  end
  