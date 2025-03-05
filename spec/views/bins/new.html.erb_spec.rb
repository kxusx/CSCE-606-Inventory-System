require 'rails_helper'

RSpec.describe "bins/new", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) }
  
  before(:each) do
    Rails.application.reload_routes!
  end
  
  before(:each) do
    assign(:bin, Bin.new(
      name: "MyString",
      location: location,
      category_name: "MyString"
    ))
  end

  it "renders new bin form" do
    render

    assert_select "form[action=?][method=?]", bins_path, "post" do

      assert_select "input[name=?]", "bin[name]"

      assert_select "select[name=?]", "bin[location_id]"

      assert_select "input[name=?]", "bin[category_name]"
    end
  end
end
