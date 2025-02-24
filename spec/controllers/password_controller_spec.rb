require 'rails_helper'

RSpec.describe PasswordController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers

  let(:user) { create(:user) }

  before(:each) do
    Rails.application.reload_routes!
  end

  describe "GET #forgot" do
    it "renders the forgot password page" do
      get :forgot
      expect(response).to render_template(:forgot)
      expect(response).to have_http_status(:ok)
      puts "✅ Test Passed: GET /forgot renders forgot password page"
    end
  end

  describe "POST #send_reset_code" do
    context "with valid email" do
      it "sends a reset code to the user" do
        post :send_reset_code, params: { email: user.email }
        user.reload

        expect(user.reset_code).not_to be_nil
        expect(user.reset_sent_at).not_to be_nil
        expect(response).to redirect_to(reset_code_path)
        expect(flash[:notice]).to eq("Reset code sent to your email.")
        puts "✅ Test Passed: POST /send_reset_code generates reset code and redirects"
      end
    end

    context "with invalid email" do
      it "redirects to forgot password page with error" do
        post :send_reset_code, params: { email: "invalid@example.com" }

        expect(response).to redirect_to(forgot_password_path)
        expect(flash[:error]).to eq("User not registered in the database")
        puts "✅ Test Passed: POST /send_reset_code handles invalid email"
      end
    end
  end

  describe "POST #verify_reset_code" do
    before do
      user.update(reset_code: "123456", reset_sent_at: Time.now)
      session[:reset_user_id] = user.id
    end

    context "with valid code" do
      it "redirects to password reset form" do
        post :verify_reset_code, params: { reset_code: "123456" }
        expect(response).to redirect_to(new_password_reset_path)
        puts "✅ Test Passed: POST /verify_reset_code with valid code"
      end
    end

    context "with invalid code" do
      it "redirects back with error message" do
        post :verify_reset_code, params: { reset_code: "wrongcode" }
        expect(response).to redirect_to(reset_code_path)
        expect(flash[:console_alert]).to eq("Invalid or expired reset code")
        puts "✅ Test Passed: POST /verify_reset_code with invalid code"
      end
    end
  end

  describe "POST #resend_reset_code" do
    before do
      user.update(reset_code: "123456", reset_sent_at: Time.now)
      session[:reset_user_id] = user.id
    end

    context "when session exists" do
      it "generates a new reset code and sends an email" do
        post :resend_reset_code
        user.reload

        expect(user.reset_code).not_to eq("123456") # Code should be different
        expect(user.reset_sent_at).to be_within(1.second).of(Time.now)
        expect(response).to redirect_to(reset_code_path)
        expect(flash[:notice]).to eq("New reset code sent to your email.")
        puts "✅ Test Passed: POST /resend_reset_code generates new reset code"
      end
    end

    context "when session expired" do
      it "redirects to forgot password page" do
        session[:reset_user_id] = nil # Simulate expired session

        post :resend_reset_code
        expect(response).to redirect_to(forgot_password_path)
        expect(flash[:console_alert]).to eq("Session expired. Please request a new reset code.")
        puts "✅ Test Passed: POST /resend_reset_code handles expired session"
      end
    end
  end

  describe "GET #reset" do
    before do
      session[:reset_user_id] = user.id
    end

    it "renders the password reset page" do
      get :reset
      expect(response).to render_template(:reset)
      puts "✅ Test Passed: GET /reset renders password reset page"
    end
  end

  describe "POST #update" do
    before do
      user.update(reset_code: "123456", reset_sent_at: Time.now)
      session[:reset_user_id] = user.id
    end

    context "with valid password" do
      it "updates the password and clears reset code" do
        post :update, params: { user: { password: "NewPass1!", password_confirmation: "NewPass1!" } }
        user.reload

        #expect(user.authenticate("NewPass1!")).to be_truthy
        expect(user.valid_password?("NewPass1!")).to be_truthy

        expect(user.reset_code).to be_nil
        expect(session[:reset_user_id]).to be_nil
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq("Password reset successful!")
        puts "✅ Test Passed: POST /update resets password successfully"
      end
    end

    context "with invalid password" do
      it "renders reset page with errors" do
        post :update, params: { user: { password: "short", password_confirmation: "short" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:reset)
        puts "✅ Test Passed: POST /update with invalid password"
      end
    end
  end
end
