require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:bin) { create(:bin, user: user, location: location) }
  let!(:bins) { create_list(:bin, 3, user: user, location:location) } 
  let(:item) { create(:item, bin: bin, location:location, user:user) }  # Ensures the item is associated with a bin


  before(:each) do
    Rails.application.reload_routes!
    assign(:item, item)
    assign(:bins, bins)
  end


  
  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      #assert_select "input[name=?]", "item[description]"

      #assert_select "input[name=?]", "item[created_date]"

      assert_select "input[name=?]", "item[value]"

      #assert_select "input[name=?]", "item[bin_id]"
      puts "✅ Test Passed: items / edit"
    end
  end
end
