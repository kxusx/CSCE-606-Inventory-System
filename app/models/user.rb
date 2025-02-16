require 'devise'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    
    #User can ahve multiple bins
    has_many :bins, dependent: :destroy 

  
    # Validations
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

    # Validate password presence, length, and complexity
    validates :password, presence: true, format: { 
      with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+\z/, 
      message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character" 
    }    
end
