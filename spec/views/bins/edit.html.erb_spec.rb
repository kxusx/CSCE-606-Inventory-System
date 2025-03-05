require 'rails_helper'

RSpec.describe "bins/edit", type: :view do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:bin) { create(:bin, user: user, location: location) }
 

  before(:each) do
    Rails.application.reload_routes!
  end

  before do
    assign(:bin, bin)  # ✅ Assign @bin so the form works
    allow(view).to receive(:bin_path).with(bin).and_return("/bins/#{bin.id}")  # ✅ Stub bin_path correctly
  end

  it "renders the edit bin form" do
    render
    assert_select "form[action=?][method=?]", "/bins/#{bin.id}", "post" do
      assert_select "input[name=?]", "bin[name]"
      assert_select "select[name=?]", "bin[location_id]"
      assert_select "input[name=?]", "bin[category_name]"
      puts "✅ Test Passed: view bins/edit"
    end
  end
end
