require 'rails_helper'

RSpec.describe Bin, type: :model do
  # Setup test data
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!', bins_count: 0) }
  let(:valid_attributes) do
    {
      name: 'Storage Box',
      user: user,
      location: "Garage",
      category_name: "Misc"
    }
  end

  # Validations
  describe 'validations' do
    it 'is valid with valid attributes' do
      bin = Bin.new(valid_attributes)
      expect(bin).to be_valid
      puts "✅ Test: Bin is valid with correct attributes - PASSED"
    end

    it 'requires a name' do
      bin = Bin.new(valid_attributes.merge(name: nil))
      expect(bin).not_to be_valid
      expect(bin.errors[:name]).to include("can't be blank")
      puts "✅ Test: Bin requires a name - PASSED"
    end

    it 'belongs to a user' do
      bin = Bin.new(valid_attributes.merge(user: nil))
      expect(bin).not_to be_valid
      puts "✅ Test: Bin requires a user - PASSED"
    end
  end

  # QR Code Tests
  describe 'QR Code Generation' do
    it 'generates a QR code upon creation' do
      bin = Bin.create!(valid_attributes)
      expect(bin.qr_code).not_to be_nil
      puts "✅ Test: QR code is generated upon creation - PASSED"
    end

    context 'URL verification' do
      it 'generates the correct QR code URL in development' do
        bin = Bin.create!(valid_attributes)
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))
        expected_url = "http://127.0.0.1:3000/bins/#{bin.id}"
        expect(bin.send(:qr_code_data)).to eq(expected_url)
        puts "✅ Test: QR code contains correct development URL - PASSED"
      end

      it 'generates the correct QR code URL in production' do
        bin = Bin.create!(valid_attributes)
        # Force Rails to behave as if it's in production
        allow(Rails.env).to receive(:production?).and_return(true)

        # Ensure ENV["APP_HOST"] is set for the test
        ENV["APP_HOST"] = "https://robert-inventory-f91e26f91bb2.herokuapp.com"

        expected_url = "#{ENV["APP_HOST"]}/bins/#{bin.id}"
        expect(bin.send(:qr_code_data)).to eq(expected_url)
        puts "✅ Test: QR code contains correct production URL - PASSED"
      end
    end
  end
end
