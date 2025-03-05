require 'rails_helper'

RSpec.describe "items/index", type: :view do
  let!(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let!(:bins) { create_list(:bin, 2, user: user, location: location) } 
  let!(:items) { create_list(:item, 2, bin: bins.first, user: user) }  # ✅ Fix: Ensure items have a user

  before(:each) do
    Rails.application.reload_routes!
    assign(:items, items)  # ✅ Assign `@items` to the view
    assign(:bins, bins)  # ✅ Assign bins in case the view references them
    render
  end

  it "renders a list of items" do
    assert_select "table tbody tr", count: 2  # ✅ Expect exactly 2 rows for items

    # ✅ Match item names dynamically regardless of table column positions
    items.each do |item|
      assert_select "tr td", text: item.name, count: 1
    end
    puts "✅ Test Passed: items / index"
  end
end
