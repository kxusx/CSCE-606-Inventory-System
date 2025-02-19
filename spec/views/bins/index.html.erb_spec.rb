require 'rails_helper'

RSpec.describe "bins/index", type: :view do
  before(:each) do
    user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")
    
    assign(:bins, [
      Bin.create!(
        name: "Name 1",
        location: "Location 1",
        category_name: "Category 1",
        user: user # Ensure bin is associated with a user
      ),
      Bin.create!(
        name: "Name 2",
        location: "Location 2",
        category_name: "Category 2",
        user: user
      )
    ])
  end

  it "renders a list of bins inside a table" do
    render

    # Ensure the table exists
    assert_select "table" do
      assert_select "thead tr th", text: "Name", count: 1
      assert_select "thead tr th", text: "Location", count: 1
      assert_select "thead tr th", text: "Category", count: 1
      assert_select "thead tr th", text: "Actions", count: 1

      # Ensure table has at least two rows for bins
      assert_select "tbody tr", count: 2

      # Ensure bin details are in the table
      assert_select "tbody tr td", text: "Name 1", count: 1
      assert_select "tbody tr td", text: "Location 1", count: 1
      assert_select "tbody tr td", text: "Category 1", count: 1

      assert_select "tbody tr td", text: "Name 2", count: 1
      assert_select "tbody tr td", text: "Location 2", count: 1
      assert_select "tbody tr td", text: "Category 2", count: 1
    end
  end
end
