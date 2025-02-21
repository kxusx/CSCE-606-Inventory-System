FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'Password123!' }
  end
end 