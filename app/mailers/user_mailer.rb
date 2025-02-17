class UserMailer < ApplicationMailer
    default from: "no-reply@inventorysystem.com"
  
    def reset_password_email(user)
      @user = user
      @reset_code = user.reset_code
  
      mail(
        to: @user.email,
        subject: "Password Reset Code for Inventory Management System"
      )
    end
end
  
