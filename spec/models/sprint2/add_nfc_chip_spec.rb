require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 
  let(:valid_attributes) do
    {
      name: 'Storage Box',
      user: user,
      location: location,
      category_name: "Misc"
    }
  end

  describe 'NFC URL Generation' do
    it 'copies the correct NFC URL in development' do
      bin = Bin.create!(valid_attributes)
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

      expected_url = "http://127.0.0.1:3000/bins/#{bin.id}"
      expect(bin.send(:qr_code_data)).to eq(expected_url)
      puts "✅ NFC URL in Development is correct - PASSED"
    end
    
    # This test verifies the NFC URL in production but is skipped in non-production environments
    # because it depends on Rails.env.production? being true.
    it 'copies the correct NFC URL in production' do
      bin = Bin.create!(valid_attributes)
      # Force Rails to behave as if it's in production
      allow(Rails.env).to receive(:production?).and_return(true)
      # Ensure ENV["APP_HOST"] is set for the test
      ENV["APP_HOST"] = "https://robert-inventory-f91e26f91bb2.herokuapp.com"
      expected_url = "#{ENV["APP_HOST"]}/bins/#{bin.id}"
      expect(bin.send(:qr_code_data)).to eq(expected_url)
      puts "✅ NFC URL in Production is correct - PASSED"
    end
  end
end
