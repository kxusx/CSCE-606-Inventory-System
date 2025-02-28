require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "Validations" do
    it "is valid with a name and a user" do
      user = User.create!(name: "Test User", email: "test@example.com", password: "Password@123")
      location = Location.new(name: "Kitchen", user: user)
      expect(location).to be_valid
      puts "✅ Test Passed: is valid with a name and a user"
    end

    it "is invalid without a name" do
      user = User.create!(name: "Test User", email: "test@example.com", password: "Password@123")
      location = Location.new(name: nil, user: user)
      expect(location).not_to be_valid
      puts "✅ Test Passed: is invalid without a name"
    end

    it "is invalid without a user" do
      location = Location.new(name: "Kitchen", user: nil)
      expect(location).not_to be_valid
      puts "✅ Test Passed: is invalid without a user"
    end
  end
end
