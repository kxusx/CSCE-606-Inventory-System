require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when logged in" do
      before(:each) do
        Rails.application.reload_routes!
        sign_in user
      end

      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
        puts "✅ Test Passed: GET /dashboard"
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get dashboard_path
        expect(response).to redirect_to("/users/sign_in")
        follow_redirect!

        # Check for a visible element from the login page
        expect(response.body).to include("Sign up")
        #expect(response.body).to include("Don't have an account?") # Adjust to actual login page text
        #expect(response.body).to match(/Sign up/i) # Case-insensitive check for "Sign up"
        #expect(response.body).to include('<form') # Ensures a login form exists
        puts "✅ Test Passed: Redirect to Login"
      end
    end
  end
end
