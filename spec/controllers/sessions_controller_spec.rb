require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }

  before(:each) do
    Rails.application.reload_routes!
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and redirects to the dashboard" do
        post new_user_session_path, params: { user: { email: user.email, password: "Password1!" } }

        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(response.body).to include("Dashboard")
        expect(controller.current_user).to eq(user)
        puts "✅ Test Passed: POST create (valid login)"
      end
    end

  describe "DELETE #destroy" do
    it "logs out the user, updates session logout_time, and redirects to login" do
      sign_in user  # Simulate logging in
      session_record = Session.create!(user: user, login_time: Time.current) # Simulate an active session

      delete destroy_user_session_path  

      expect(session_record.reload.logout_time).not_to be_nil 
      expect(response).to redirect_to(new_user_session_path) 
      expect(controller.current_user).to be_nil  
      puts "✅ Test Passed: DELETE destroy (logout)"
    end
  end
 

    context "with invalid credentials" do
      it "renders the login page with an error message" do
        post new_user_session_path, params: { user: { email: user.email, password: "wrongpassword" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq("Invalid Email or password.")
        puts "✅ Test Passed: POST create (invalid login)"
      end
    end
  end
end
