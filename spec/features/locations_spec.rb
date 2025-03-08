require 'rails_helper'
include Rails.application.routes.url_helpers

RSpec.feature "Location Management", type: :feature do
  let!(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password@123") }

  before do
    login_as(user, scope: :user) # Simulates a logged-in user
  end

  scenario "User creates a new location" do
    visit new_location_path

    fill_in "Name", with: "Kitchen"
    click_button "Create Location"

    expect(page).to have_text("Location created successfully!")
    expect(page).to have_text("Kitchen")
  end

  scenario "User views list of locations" do
    Location.create!(name: "Garage", user: user)

    visit locations_path
    expect(page).to have_text("Garage")
  end

  scenario "User edits a location" do
    location = Location.create!(name: "Basement", user: user)

    visit edit_location_path(location)
    fill_in "Name", with: "Attic"
    click_button "Update Location"

    expect(page).to have_text("Location updated successfully!")
    expect(page).to have_text("Attic")
  end

  scenario "User submits empty location name" do
    visit new_location_path
    click_button "Create Location" # Ensure this matches your form button name

    # ✅ Check that it successfully redirects (assuming it redirects to locations_path)
    expect(page).to have_current_path(locations_path)
  end
end
