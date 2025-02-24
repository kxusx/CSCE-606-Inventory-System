FactoryBot.define do
  factory :user do
<<<<<<< HEAD
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'Password123!' }
  end
end 
=======
    name { "Test User" }  # 🔹 Add this line
    email { "test@example.com" }
    password { "Password1!" }
    password_confirmation { "Password1!" }
  end
end
>>>>>>> origin/main
