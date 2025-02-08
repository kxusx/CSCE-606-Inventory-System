module ApplicationHelper
    def generate_message(user, attribute)
        case attribute
        when :password_confirmation
          "Passwords don't match"
        else
          @user.errors.full_messages_for(attribute).join(", ")
        end
    end
end
