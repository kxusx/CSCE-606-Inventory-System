
require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'Password1!') }
  let(:bin) { Bin.create!(name: 'Storage Box', user: user, location: "Garage", category_name: "Misc") }
  let!(:item) do
    Item.create!(
      name: 'Test Item',
      description: 'A test item',
      value: 100.00,
      bin: bin,
      no_bin: false
    )
  end

  describe 'bin removal behavior' do
    context 'when removing from bin' do
      it 'sets bin_id to nil instead of deleting the item' do
        expect {
          item.update!(bin_id: nil, no_bin: true)
        }.not_to change(Item, :count)

        item.reload
        expect(item.bin).to be_nil
        expect(item.no_bin).to be true
      end

      it 'maintains all other attributes after bin removal' do
        original_name = item.name
        original_description = item.description
        original_value = item.value

        item.update!(bin_id: nil, no_bin: true)
        item.reload

        expect(item.name).to eq(original_name)
        expect(item.description).to eq(original_description)
        expect(item.value).to eq(original_value)
      end

      it 'allows reassignment to a different bin after removal' do
        item.update!(bin_id: nil, no_bin: true)
        new_bin = Bin.create!(name: 'New Box', user: user, location: "Basement", category_name: "Misc")
        
        expect {
          item.update!(bin: new_bin, no_bin: false)
        }.to change { item.bin }.from(nil).to(new_bin)
      end
    end

    context 'when attempting actual deletion' do
      it 'prevents actual deletion and updates bin assignment instead' do
        expect {
          item.destroy
        }.not_to change(Item, :count)

        item.reload
        expect(item.bin_id).to be_nil
        expect(item.no_bin).to be true
      end
    end

    context 'validation and state' do
      it 'requires no_bin to be true when bin_id is nil' do
        item.bin_id = nil
        item.no_bin = false
        expect(item).not_to be_valid
      end

      it 'requires no_bin to be false when bin_id is present' do
        item.no_bin = true
        expect(item).not_to be_valid
      end

      it 'tracks the unassigned status correctly' do
        expect(item.unassigned?).to be false
        
        item.update!(bin_id: nil, no_bin: true)
        expect(item.unassigned?).to be true
      end
    end
  end
end
