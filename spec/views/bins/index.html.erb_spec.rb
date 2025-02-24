require 'rails_helper'

RSpec.describe "bins/index", type: :view do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }
  let(:bins) { create_list(:bin, 2, user: user) }  # ✅ Generate bins dynamically

  before(:each) do
    Rails.application.reload_routes!
  end


  before do
    assign(:bins, bins)
    allow(view).to receive(:bin_path) { |bin| "/bins/#{bin.id}" }  # ✅ Stub bin_path for each bin
  end

  it "renders a list of bins inside a table" do
    render

    # Ensure the table exists
    assert_select "table" do
      assert_select "thead tr th", text: "Name", count: 1
      assert_select "thead tr th", text: "Location", count: 1
      assert_select "thead tr th", text: "Category", count: 1
      assert_select "thead tr th", text: "Actions", count: 1

      # Ensure table has the correct number of rows
      assert_select "tbody tr", count: 2

      # ✅ Use dynamically generated bin names from FactoryBot
      bins.each do |bin|
        assert_select "tbody tr td", text: bin.name, count: 1
        assert_select "tbody tr td", text: bin.location, count: 1
        assert_select "tbody tr td", text: bin.category_name, count: 1
      end
    end
  end
end
