require 'rails_helper'

RSpec.describe LocationsController, type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password@123") }
  let!(:location) { Location.create!(name: "Kitchen", user: user) }

  before(:each) do
    Rails.application.reload_routes!
    sign_in user
  end

  describe "GET /index" do
    it "returns a successful response" do
      get locations_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /index"
    end
  end

  describe "POST /create" do
    it "creates a new location with valid attributes" do
      expect {
        post locations_path, params: { location: { name: "Attic" } }
      }.to change(Location, :count).by(1)
      expect(response).to redirect_to(locations_path)
      follow_redirect!
      expect(response.body).to include("Location created successfully!")
      puts "✅ Test Passed: POST /create"
    end

    it "does not create a location when name is empty" do
      expect {
        post locations_path, params: { location: { name: "" } }
      }.not_to change(Location, :count)
      expect(response.body).to include("Failed to create location")
      puts "✅ Test Passed:does not create a location when name is empty"
    end
  end

  describe "PATCH /update" do
    it "updates the location with valid attributes" do
      patch location_path(location), params: { location: { name: "Garage" } }
      expect(location.reload.name).to eq("Garage")
      expect(response).to redirect_to(locations_path)
      follow_redirect!
      expect(response.body).to include("Location updated successfully!")
      puts "✅ Test Passed:updates the location with valid attributes"
    end

    it "does not update the location when name is empty" do
      patch location_path(location), params: { location: { name: "" } }
      expect(location.reload.name).to eq("Kitchen")  # Name should remain unchanged
      expect(response.body).to include("Failed to update location")
      puts "✅ Test Passed:does not update the location when name is empty"
    end
  end
end
