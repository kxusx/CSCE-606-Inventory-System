class PasswordController < ApplicationController
    require 'securerandom'
  
    def forgot
      render 'password/forgot'
    end
  
    def send_reset_code
      @user = User.find_by(email: params[:email])
      if @user
        @user.update(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)
        # Simulate sending email
        puts "Reset code sent to #{@user.email}: #{@user.reset_code}"
        redirect_to reset_code_path
      else
        flash[:error] = "Mail not registered in the database"
        redirect_to forgot_password_path
      end
    end
  
    def reset_code
      render 'password/reset_code'
    end
  
    def verify_reset_code
      if current_reset_user&.reset_sent_at&.>(15.minutes.ago) && current_reset_user&.reset_code == params[:reset_code]
        redirect_to new_password_reset_path
      else
        flash[:error] = "Invalid or expired reset code"
        redirect_to reset_code_path
      end
    end
  
    def resend_reset_code
      if current_reset_user
        current_reset_user.update(reset_code: SecureRandom.hex(3), reset_sent_at: Time.now)
        puts "New reset code sent: #{current_reset_user.reset_code}"
        redirect_to reset_code_path
      else
        redirect_to forgot_password_path
      end
    end
  
    def reset
      render 'password/reset'
    end
  
    def update
      if current_reset_user && params[:password].match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/)
        current_reset_user.update(password: params[:password])
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
  