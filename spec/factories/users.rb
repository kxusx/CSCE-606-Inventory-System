FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }  # ✅ Ensures unique emails
    password { "Password1!" }
    password_confirmation { "Password1!" }
  end
end
