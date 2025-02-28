require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }
  let(:bin) { create(:bin, user: user) }
  let(:item) { create(:item, bin: bin) }  # Ensures the item is associated with a bin
  let!(:bins) { create_list(:bin, 3, user: user) } 

  before(:each) do
    Rails.application.reload_routes!
    sign_in user
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
    end
  end
end
