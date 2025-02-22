require 'rails_helper'

RSpec.describe "Items", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }
  let(:bin) { create(:bin, user: user) }
  let(:item) { create(:item, bin: bin) }  # Ensures the item is associated with a bin

  before(:each) do
    Rails.application.reload_routes!
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get items_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /index"
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get item_path(item)
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /show"
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_item_path
      expect(response).to have_http_status(:success)
      puts "✅ Test Passed: GET /new"
    end
  end

  describe "POST /create" do
    it "creates a new item and redirects to item page" do
      expect {
        post items_path, params: { item: { name: "New Item", description: "New test", value: 50, bin_id: bin.id } }
      }.to change(Item, :count).by(1)

      expect(response).to redirect_to(item_path(Item.last))
      puts "✅ Test Passed: POST /create"
    end
  end

  describe "PATCH /update" do
    it "updates an existing item" do
      patch item_path(item), params: { item: { name: "Updated Item Name" } }
      expect(response).to redirect_to(item_path(item))
      follow_redirect!
      expect(response.body).to include("Updated Item Name")
      puts "✅ Test Passed: PATCH /update"
    end
  end

  describe "DELETE /destroy" do
    it "deletes an item and redirects to items list" do
      item_to_delete = bin.items.create!(name: "Delete Me", description: "Test", value: 20)
      
      expect {
        delete item_path(item_to_delete)
      }.to change(Item, :count).by(-1)

      expect(response).to redirect_to(items_path)
      puts "✅ Test Passed: DELETE /destroy"
    end
  end
end
