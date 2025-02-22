require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers

  before(:each) do
    Rails.application.reload_routes!
  end

  describe "GET /new" do
    it "returns http success" do
      get new_user_registration_path
      expect(response).to have_http_status(:success)
    end
  end
end
