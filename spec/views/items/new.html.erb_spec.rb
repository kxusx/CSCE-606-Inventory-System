require 'rails_helper'

RSpec.describe "items/new", type: :view do
  let!(:user) { create(:user) }  # ✅ Ensure user exists
  let(:location) { create(:location, user: user) } 
  let!(:bins) { create_list(:bin, 3, user: user, location:location) }  # ✅ Ensure bins exist and belong to user

  before(:each) do
    Rails.application.reload_routes!
    assign(:item, Item.new(
      name: "MyString",
      description: "MyString",
      created_date: Date.today,
      value: 100,
      bin: bins.first,
      user: user  # ✅ Ensure user is assigned
    ))

    assign(:bins, bins)  # ✅ Assign bins to match the view
    allow(view).to receive(:items_path).and_return("/items")  # ✅ Ensure items_path works

    render  # ✅ Render the view
  end

  it "renders new item form" do
    assert_select "form[action=?][method=?]", "/items", "post" do
      assert_select "input[name=?]", "item[name]"
      assert_select "input[name=?]", "item[value]"  # ✅ Ensure the value field exists
      assert_select "select[name=?]", "item[bin_id]"  # ✅ Ensure bin selection is a dropdown
    end

    puts "✅ Test Passed: items / new"
  end
end
