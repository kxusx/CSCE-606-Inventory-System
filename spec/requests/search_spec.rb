require 'rails_helper'

# spec/requests/bins_spec.rb
RSpec.describe "GET /bins", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:location) { create(:location, user: user) }
  let(:other_location) { create(:location, user: other_user) } 
  let!(:bin1) { create(:bin, name: "Storage Bin", user: user, location: location) }
  let!(:bin2) { create(:bin, name: "Office Supplies", user: user, location: location) }
  let!(:other_user_bin) { create(:bin, name: "other_bin", user: other_user, location: other_location) } # Belongs to another user

  before(:each) do
    Rails.application.reload_routes!
    sign_in user
  end

  context "when searching by name" do
    it "returns bins matching the search query" do
      get bins_path, params: { name: "Storage" }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Storage Bin")
      expect(response.body).not_to include("Office Supplies")
      expect(response.body).not_to include(other_user_bin.name) # ✅ Ensures it does NOT return other users' bins
      puts "✅ Test Passed: Searching for bins by name"
    end
  end
end
