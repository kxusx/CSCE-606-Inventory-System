require 'rails_helper'

RSpec.describe "bins/show", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let!(:bin) { create(:bin, user: user, location: location, name: "Bin 1") }

  before(:each) do
    assign(:bin, bin)
    Rails.application.reload_routes!
  end

  it "renders bin attributes in <p>" do
    render

    expect(rendered).to match(/Bin \d+/)
    expect(rendered).to match(/Test Location \d+/)
    expect(rendered).to match(/Category \d+/)
    puts "✅ Test Passed: view bins/show"
  end
end
