require 'rails_helper'

RSpec.describe Item, type: :model do
  # Setup test data
  let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password123') }
  let(:bin) { Bin.create(name: 'Holiday Decorations', location: 'Attic') }
  let(:valid_attributes) do
    {
      name: 'Christmas Lights',
      description: 'Box of outdoor LED lights',
      storage_location: 'Attic',
      user: user,
      bin: bin
    }
  end

  # Validations
  describe 'validations' do
    it 'is valid with valid attributes' do
      item = Item.new(valid_attributes)
      expect(item).to be_valid
    end

    it 'requires a name' do
      item = Item.new(valid_attributes.merge(name: nil))
      expect(item).not_to be_valid
      expect(item.errors[:name]).to include("can't be blank")
    end

    it 'requires a storage location' do
      item = Item.new(valid_attributes.merge(storage_location: nil))
      expect(item).not_to be_valid
      expect(item.errors[:storage_location]).to include("can't be blank")
    end

    it 'requires a user' do
      item = Item.new(valid_attributes.merge(user: nil))
      expect(item).not_to be_valid
      expect(item.errors[:user]).to include("can't be blank")
    end
  end

  # Associations
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a bin' do
      association = described_class.reflect_on_association(:bin)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to eq true
    end
  end

  # CRUD operations
  describe 'CRUD operations' do
    describe 'create' do
      it 'creates a new item with valid attributes' do
        expect {
          Item.create(valid_attributes)
        }.to change(Item, :count).by(1)
      end

      it 'saves all provided attributes' do
        item = Item.create(valid_attributes)
        expect(item.name).to eq('Christmas Lights')
        expect(item.description).to eq('Box of outdoor LED lights')
        expect(item.storage_location).to eq('Attic')
      end
    end

    describe 'read' do
      let!(:item) { Item.create(valid_attributes) }

      it 'retrieves an existing item' do
        found_item = Item.find(item.id)
        expect(found_item).to eq(item)
      end

      it 'retrieves items by storage location' do
        items = Item.where(storage_location: 'Attic')
        expect(items).to include(item)
      end

      it 'retrieves items by user' do
        items = user.items
        expect(items).to include(item)
      end
    end

    describe 'update' do
      let!(:item) { Item.create(valid_attributes) }

      it 'updates the item attributes' do
        expect {
          item.update(name: 'New LED Lights', storage_location: 'Garage')
        }.to change { item.name }.to('New LED Lights')
          .and change { item.storage_location }.to('Garage')
      end

      it 'moves item to a different bin' do
        new_bin = Bin.create(name: 'Storage Box 1', location: 'Garage')
        expect {
          item.update(bin: new_bin)
        }.to change { item.bin }.to(new_bin)
      end
    end

    describe 'delete' do
      let!(:item) { Item.create(valid_attributes) }

      it 'removes the item' do
        expect {
          item.destroy
        }.to change(Item, :count).by(-1)
      end

      it 'can be restored if accidentally deleted', if: Item.respond_to?(:with_deleted) do
        item.destroy
        expect {
          item.restore
        }.to change(Item, :count).by(1)
      end
    end
  end
end

# helped by cursor