require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }

  before(:each) do
    Rails.application.reload_routes!
  end

  describe "GET /login" do
    it "returns http success" do
      get new_user_session_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET login"
    end
  end

  # ✅ Test login action (signing in the user)
  describe "POST /login" do
    it "logs in the user successfully" do
      post user_session_path, params: { user: { email: user.email, password: "Password1!" } }
      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
      expect(response.body).to include("Dashboard")
      puts "✅ Test Passed: POST login"
    end
  end

  # ✅ Test logout action (signing out the user)
  describe "DELETE /logout" do
    it "logs out the user successfully" do
      sign_in user  # Ensure the user is logged in before logging out
      delete destroy_user_session_path  # Use the Devise logout path
      expect(response).to redirect_to(unauthenticated_root_path)  #  Update expectation
      follow_redirect!
      expect(response.body).to include("Password")  # ✅ Ensure the login page is shown
      puts "✅ Test Passed: DELETE logout"
    end
  end

  # ✅ Test the `after_sign_in_path_for` redirection
  describe "after sign in redirection" do
    it "redirects user to the correct path after login" do
      sign_in user
      get unauthenticated_root_path # Ensure we use the correct route
      expect(response).to redirect_to(dashboard_path) # Ensure redirection happens correctly
      puts "✅ Test Passed: after sign in redirection"
    end
  end
end
