require 'rails_helper'

RSpec.feature "Locations", type: :feature do
  let(:user) { create(:user) }
  let!(:location1) { create(:location, name: "Tech Lab", user: user) }
  let!(:location2) { create(:location, name: "Living Room", user: user) }
  let!(:location3) { create(:location, name: "Office Desk", user: user) }

  before do
    Rails.application.reload_routes!
    sign_in user
    visit locations_path
  end

  scenario "renders the locations table" do
    expect(page).to have_content("Your Locations")
    expect(page).to have_content("Tech Lab")
    expect(page).to have_content("Living Room")
    expect(page).to have_content("Office Desk")
  end
  
  scenario "typing in search input fetches results", js: true do
    find("#search-icon").click
    fill_in "search-input", with: "Tech Lab"
  
    expect(page).to have_content("Tech Lab")
    expect(page).not_to have_content("Living Room")
  end

  scenario "opens the add location modal" do
    find(".addLocationBtn").click
    expect(page).to have_selector("#addLocationModal", visible: true)
  end

  scenario "adds a new location" do
    find(".addLocationBtn").click
    within("#addLocationModal") do
      fill_in "location[name]", with: "New Location"
    end
    click_button "Add Location"
    expect(page).to have_content("New Location")
  end
end
