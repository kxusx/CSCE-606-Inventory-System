require 'rails_helper'

RSpec.describe Bin, type: :model do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!', bins_count: 0) }
  let(:valid_attributes) do
    {
      name: 'Storage Box',
      user: user,
      location: "Garage",
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

    it 'copies the correct NFC URL in production' do
      bin = Bin.create!(valid_attributes)
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))

      expected_url = "https://inventory-system-lightfoot-c73b05a2c5ae.herokuapp.com/bins/#{bin.id}"
      expect(bin.send(:qr_code_data)).to eq(expected_url)
      puts "✅ NFC URL in Production is correct - PASSED"
    end
  end
end
