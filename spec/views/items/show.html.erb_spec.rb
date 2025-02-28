require 'rails_helper'

RSpec.describe "items/show", type: :view do
  let!(:user) { create(:user) }
  let!(:bin) { create(:bin, user: user) }  # ✅ Create an actual bin
  let!(:item) { create(:item, name: "Test Item", description: "Test Description", value: 150, bin: bin) }

  before(:each) do
    assign(:item, item)  # ✅ Assign `@item` to the view
  end

  it "renders item attributes in <p>" do
    render

    expect(rendered).to match(/Test Item/)
    expect(rendered).to match(/Test Description/)
    expect(rendered).to match(/\$150.00/)  # ✅ Matches formatted currency
    expect(rendered).to match(/#{bin.name}/)  # ✅ Matches bin name instead of bin_id
  end
end
