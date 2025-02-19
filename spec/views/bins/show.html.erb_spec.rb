require 'rails_helper'

RSpec.describe "bins/show", type: :view do
  before(:each) do
    user = User.create!(name: "Test User", email: "test@example.com", password: "Password1!")

    assign(:bin, Bin.create!(
      name: "Test Bin",
      location: "Test Location",
      category_name: "Test Category",
      user: user # Ensure the bin has a valid user
    ))
  end

  it "renders bin attributes in <p>" do
    render

    expect(rendered).to match(/Test Bin/)
    expect(rendered).to match(/Test Location/)
    expect(rendered).to match(/Test Category/)
  end
end
