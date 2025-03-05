require 'rails_helper'

RSpec.describe "dashboard/index", type: :view do
  before(:each) do
    Rails.application.reload_routes!
  end

  before do
    # ✅ Stub route helpers to prevent "undefined method" errors
    allow(view).to receive(:bins_path).and_return("/bins")
    allow(view).to receive(:items_path).and_return("/items")
    render template: "dashboard/index", layout: "layouts/application"
    #puts rendered

  end

  it "displays the navigation links" do
    expect(rendered).to include("BINS")  # ✅ Direct text search
    expect(rendered).to include("ITEMS")
    puts "✅ Test Passed: view nav links"
  end

#  it "displays the Dashboard heading" do
#    expect(rendered).to have_selector("h1", text: "Dashboard")
#  end

  it "has search inputs and buttons" do
    expect(rendered).to have_selector("input[placeholder='Search by Bin/Category...']")
    expect(rendered).to have_button("Search", count: 3)  # three search buttons
    expect(rendered).to have_selector("input[placeholder='Search Items...']")
    puts "✅ Test Passed: inputs and buttons"
  end

  it "has the 'Search by Location' button" do
    expect(rendered).to have_button("Search by Location")
    puts "✅ Test Passed: search by location button"
  end

  it "displays the user profile icon" do
    expect(rendered).to have_selector("div", text: "A")  # ✅ Ensures the profile icon with 'A' exists
    puts "✅ Test Passed: display user profile icon"
  end
end
