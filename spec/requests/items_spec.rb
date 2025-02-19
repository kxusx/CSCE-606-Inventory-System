require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { User.create!(name: "Test User", email: "test@example.com", password: "Password1!") }
  let(:bin) { user.bins.create!(name: "Storage Bin", location: "Garage", category_name: "Misc") }
  let(:item) { bin.items.create!(name: "Item A", description: "A test item", value: 100) }

  before do
    post login_path, params: { email: user.email, password: "Password1!" }
    follow_redirect!
  end

  describe "GET /index" do
    it "returns http success" do
      get items_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get item_path(item)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_item_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new item and redirects to item page" do
      expect {
        post items_path, params: { item: { name: "New Item", description: "New test", value: 50, bin_id: bin.id } }
      }.to change(Item, :count).by(1)

      expect(response).to redirect_to(item_path(Item.last))
    end
  end

  describe "PATCH /update" do
    it "updates an existing item" do
      patch item_path(item), params: { item: { name: "Updated Item Name" } }
      expect(response).to redirect_to(item_path(item))
      follow_redirect!
      expect(response.body).to include("Updated Item Name")
    end
  end

  describe "DELETE /destroy" do
    it "deletes an item and redirects to items list" do
      item_to_delete = bin.items.create!(name: "Delete Me", description: "Test", value: 20)
      
      expect {
        delete item_path(item_to_delete)
      }.to change(Item, :count).by(-1)

      expect(response).to redirect_to(items_path)
    end
  end
end
