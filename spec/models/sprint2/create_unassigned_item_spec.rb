require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location, user: user) } 

  describe 'creating unassigned items' do
    context 'when creating an item without a bin' do
      let(:unassigned_item) do
        Item.create!(
          name: 'Unassigned Item',
          description: 'An item without a bin',
          value: 150.00,
          no_bin: true,
          user: user
        )
      end

      it 'creates successfully without a bin' do
        expect(unassigned_item).to be_valid
        expect(unassigned_item.persisted?).to be true
        puts "✅ Test: Item created successfully without bin - PASSED"
      end

      it 'has correct initial state' do
        expect(unassigned_item.bin).to be_nil
        expect(unassigned_item.bin_id).to be_nil
        expect(unassigned_item.no_bin).to be true
        puts "✅ Test: Item initial state is correct - PASSED"
      end

      it 'maintains all attributes correctly' do
        expect(unassigned_item.name).to eq('Unassigned Item')
        expect(unassigned_item.description).to eq('An item without a bin')
        expect(unassigned_item.value).to eq(150.00)
        puts "✅ Test: Item attributes set correctly - PASSED"
      end

      it 'is marked as unassigned' do
        expect(unassigned_item.unassigned?).to be true
        puts "✅ Test: Item correctly marked as unassigned - PASSED"
      end
    end

    context 'validation rules' do
      it 'requires no_bin to be true when created without bin' do
        item = Item.new(
          name: 'Test Item',
          description: 'Test Description',
          value: 100.00,
          bin_id: nil,
          no_bin: false  # This should make it invalid
        )
        expect(item).not_to be_valid
        expect(item.errors[:no_bin]).to include("must be true when item is not assigned to a bin")
        puts "✅ Test: Validates no_bin must be true when unassigned - PASSED"
      end

      it 'still requires other mandatory fields' do
        item = Item.new(no_bin: true)  # Missing required fields
        expect(item).not_to be_valid
        expect(item.errors[:name]).to include("can't be blank")
        expect(item.errors[:value]).to include("is not a number")
        puts "✅ Test: Still validates required fields - PASSED"
      end

      it 'validates value is non-negative' do
        item = Item.new(
          name: 'Test Item',
          description: 'Test Description',
          value: -10.00,
          no_bin: true
        )
        expect(item).not_to be_valid
        expect(item.errors[:value]).to include("must be greater than or equal to 0")
        puts "✅ Test: Validates non-negative value - PASSED"
      end
    end

    context 'when later assigning to a bin' do
      let(:unassigned_item) do
        Item.create!(
          name: 'Initially Unassigned',
          description: 'Test item',
          value: 75.00,
          no_bin: true,
          user: user
        )
      end

      it 'can be assigned to a bin later' do
        bin = Bin.create!(name: 'New Bin', user: user, location: location, category_name: "Misc")
        
        expect {
          unassigned_item.update!(bin: bin, no_bin: false)
        }.to change { unassigned_item.bin }.from(nil).to(bin)
          .and change { unassigned_item.no_bin }.from(true).to(false)
        puts "✅ Test: Can be assigned to bin later - PASSED"
      end
    end
  end
end