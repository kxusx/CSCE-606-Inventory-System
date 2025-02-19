require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password1!") }

  describe "GET /dashboard" do
    context "when logged in" do
      before do
        post login_path, params: { email: user.email, password: "Password1!" }
        follow_redirect!
      end

      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get dashboard_path
        expect(response).to redirect_to(login_path)
        follow_redirect!

        # Check for a visible element from the login page
        expect(response.body).to include("Don't have an account?") # Adjust to actual login page text
        expect(response.body).to match(/Sign up/i) # Case-insensitive check for "Sign up"
        expect(response.body).to include('<form') # Ensures a login form exists
      end
    end
  end
end
