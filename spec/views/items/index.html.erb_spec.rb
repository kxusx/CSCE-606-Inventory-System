RSpec.describe "items/index", type: :view do
  let!(:user) { create(:user) }
  let!(:bins) { create_list(:bin, 2, user: user) }
  let!(:items) { create_list(:item, 2, bin: bins.first) }  # ✅ Ensure items belong to a bin

  before(:each) do
    assign(:items, items)  # ✅ Assign `@items` so the view can use it
    render
  end

  it "renders a list of items" do
    assert_select "table tbody tr", count: 2  # ✅ Expect exactly 2 rows for items
    assert_select "tr td:nth-child(2)", text: items.first.name, count: 1  # ✅ Check first item's name in the correct column
    assert_select "tr td:nth-child(2)", text: items.last.name, count: 1   # ✅ Check last item's name in the correct column
  end
end
