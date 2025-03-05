require 'rails_helper'

RSpec.describe "items/show", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:bin) { create(:bin, user: user, location: location) }
  let!(:item) { create(:item, name: "Test Item", description: "Test Description", value: 150, bin: bin, user: user) }  # ✅ Ensure item has a user

  before(:each) do
    Rails.application.reload_routes!
    assign(:item, item)  # ✅ Assign `@item` to the view
  end

  it "renders item attributes in <p>" do
    render

    expect(rendered).to match(/Test Item/)
    expect(rendered).to match(/Test Description/)
    expect(rendered).to match(/150/)  # ✅ Matches value without currency symbol
    expect(rendered).to match(/#{bin.name}/)  # ✅ Matches bin name instead of bin_id
    puts "✅ Test Passed: items / show"
  end
end
