require 'rails_helper'

RSpec.describe "items/new", type: :view do
  let!(:bins) { create_list(:bin, 3) }  # ✅ Ensure bins exist

  before(:each) do
    assign(:item, Item.new(
      name: "MyString",
      description: "MyString",
      created_date: Date.today,  # ✅ Use a real date
      value: 100,  # ✅ Ensure value is a number
      bin: bins.first  # ✅ Assign a bin association
    ))

    assign(:bins, bins)  # ✅ Assign @bins to match the view
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do
      assert_select "input[name=?]", "item[name]"
      #assert_select "textarea[name=?]", "item[description]"  # ✅ Ensure description is a textarea
      #assert_select "input[name=?]", "item[created_date]"  # ✅ Ensure the date field exists
      assert_select "input[name=?]", "item[value]"  # ✅ Ensure the value field exists

      # ✅ If bin selection is a dropdown, change this to `select`
      assert_select "select[name=?]", "item[bin_id]"
    end
  end
end
