require 'rails_helper'

RSpec.describe "bins/edit", type: :view do
  before do
    @user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")
    @bin = Bin.create!(
      name: "MyString",
      location: "MyString",
      category_name: "MyString",
      user: @user # Associate the bin with a user
    )
    assign(:bin, @bin)
  end

  it "renders the edit bin form" do
    render
    assert_select "form[action=?][method=?]", bin_path(@bin), "post" do
      assert_select "input[name=?]", "bin[name]"
      assert_select "input[name=?]", "bin[location]"
      assert_select "input[name=?]", "bin[category_name]"
    end
  end
end
