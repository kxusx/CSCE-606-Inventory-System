require 'rails_helper'

RSpec.feature "User Authentication", type: :feature do
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  before(:each) do
    Warden.test_mode!
  end

  let!(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password@123") }

  scenario "User logs in successfully" do
    visit "/users/sign_in"  # ✅ Ensure this matches your actual route

    # ✅ Debug: Print page source to verify elements exist
    puts "------ PAGE CONTENT ------"
    puts page.html  # 🛠 Prints full HTML Capybara sees
    puts "--------------------------"

    # ✅ Ensure form is present before interacting
    expect(page).to have_selector("form", wait: 5)

    # ✅ Verify fields exist before using them
    unless page.has_selector?("input[name='user[email]']", wait: 5)
      puts "❌ Email field NOT found!"
      fail "Test Failed: Email field missing!"
    end

    unless page.has_selector?("input[name='user[password]']", wait: 5)
      puts "❌ Password field NOT found!"
      fail "Test Failed: Password field missing!"
    end

    # ✅ Fill in login form
    find("input[name='user[email]']").set(user.email)
    find("input[name='user[password]']").set("Password@123")

    # ✅ Click login button
    click_button "Log in"

    # ✅ Ensure successful login message appears
    expect(page).to have_text("Signed in successfully")

    puts "✅ Test Passed: User successfully logged in"
  end
end
