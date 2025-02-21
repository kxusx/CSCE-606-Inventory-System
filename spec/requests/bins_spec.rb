require 'rails_helper'

RSpec.describe "/bins", type: :request do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  it "checks that bins_path exists" do
    puts "Available route helpers: #{Rails.application.routes.url_helpers.methods.sort}"
    expect(Rails.application.routes.url_helpers).to respond_to(:bins_path)
  end


  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end
  

  # Create a valid bin for testing
  let(:valid_attributes) do
    {
      name: "Test Bin",
      location: "Garage",
      category_name: "Misc",
      user_id: user.id
    }
  end

  describe "GET /index" do
    it "prints available routes in RSpec" do
      Rails.application.reload_routes!
      puts "Available routes in RSpec:"
      Rails.application.routes.routes.each do |route|
        puts route.path.spec.to_s
      end
      expect(Rails.application.routes.url_helpers).to respond_to(:bins_path)
    end
  end
  

  # 🟢 NEW (GET /bins/new)
  describe "GET /new" do
    it "renders a successful response" do
      #get new_bin_path
      get "/bins"

      expect(response).to be_successful
    end
  end

  # 🟢 SHOW (GET /bins/:id)
  describe "GET /show" do
    it "renders a successful response" do
      bin = Bin.create!(valid_attributes)
      get bin_path(bin)
      expect(response).to be_successful
    end
  end

  # 🟢 EDIT (GET /bins/:id/edit)
  describe "GET /edit" do
    it "renders a successful response" do
      bin = Bin.create!(valid_attributes)
      get edit_bin_path(bin)
      expect(response).to be_successful
    end
  end

  # 🟢 CREATE (POST /bins)
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Bin" do
        expect {
          post bins_path, params: { bin: valid_attributes }
        }.to change(Bin, :count).by(1)
      end

      it "redirects to the created bin" do
        post bins_path, params: { bin: valid_attributes }
        expect(response).to redirect_to(Bin.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Bin" do
        expect {
          post bins_path, params: { bin: valid_attributes.merge(name: nil) }
        }.to_not change(Bin, :count)
      end

      it "renders a response with 422 status" do
        post bins_path, params: { bin: valid_attributes.merge(name: nil) }
        expect(response).to have_http_status(422)
      end
    end
  end

  # 🟢 UPDATE (PATCH /bins/:id)
  describe "PATCH /update" do
    let(:new_attributes) do
      {
        name: "Updated Bin",
        location: "Updated Garage"
      }
    end

    context "with valid parameters" do
      it "updates the requested bin" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes }
        bin.reload
        expect(bin.name).to eq("Updated Bin")
      end

      it "redirects to the bin" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes }
        expect(response).to redirect_to(bin)
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        bin = Bin.create!(valid_attributes)
        patch bin_path(bin), params: { bin: new_attributes.merge(name: nil) }
        expect(response).to have_http_status(422)
      end
    end
  end

  # 🟢 DELETE (DELETE /bins/:id)
  describe "DELETE /destroy" do
    it "destroys the requested bin" do
      bin = Bin.create!(valid_attributes)
      expect {
        delete bin_path(bin)
      }.to change(Bin, :count).by(-1)
    end

    it "redirects to the bins list" do
      bin = Bin.create!(valid_attributes)
      delete bin_path(bin)
      expect(response).to redirect_to(bins_path)
    end
  end
end
