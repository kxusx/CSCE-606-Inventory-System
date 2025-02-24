require 'rails_helper'

RSpec.feature "User Authentication", type: :feature do
  include Warden::Test::Helpers
  before(:each) { Warden.test_mode! }

  let!(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password@123") }

  scenario "User logs in successfully" do
    visit new_user_session_path  # Devise-generated path

    expect(page).to have_selector("input[name='user[email]']", visible: true)
    expect(page).to have_selector("input[name='user[password]']", visible: true)
    
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: "Password@123"
    click_button "Log in"

    expect(page).to have_text("Signed in successfully")
  end

  scenario "User fails to log in with invalid credentials" do
    visit new_user_session_path

    fill_in "user[email]", with: "wrong@example.com"
    fill_in "user[password]", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_text("Invalid Email or password.")
  end

  scenario "User logs out successfully" do
    login_as(user, scope: :user)
    visit root_path

    click_link "Logout"

    expect(page).to have_text("Signed out successfully")
  end
end
