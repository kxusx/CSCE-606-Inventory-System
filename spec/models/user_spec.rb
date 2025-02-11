require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  describe 'validations' do
    it 'requires a name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'requires an email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires a unique email' do
      existing_user = User.create(name: 'Test User', email: 'test@example.com', password: 'password123')
      user = User.new(email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'requires a valid email format' do
      user = User.new(email: 'invalid_email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'requires password to be at least 6 characters' do
      user = User.new(password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  # Authentication
  describe 'authentication' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      expect(user.authenticate('wrongpassword')).to be false
    end
  end

  # Associations
  describe 'associations' do
    it 'has many items' do
      association = described_class.reflect_on_association(:items)
      expect(association.macro).to eq :has_many
    end
  end

  # Instance methods
  describe '#full_name' do
    it 'returns the full name of the user' do
      user = User.new(first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq 'John Doe'
    end
  end

  # Password reset functionality
  describe 'password reset' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password123') }

    it 'generates a password reset token' do
      expect {
        user.generate_password_reset_token
      }.to change { user.reset_password_token }.from(nil)
    end

    it 'sets password reset token expiry' do
      expect {
        user.generate_password_reset_token
      }.to change { user.reset_password_token_expires_at }.from(nil)
    end

    it 'validates reset token expiration' do
      user.generate_password_reset_token
      user.reset_password_token_expires_at = 1.hour.ago
      expect(user.password_reset_token_valid?).to be false
    end
  end

  # User status
  describe 'user status' do
    let(:user) { User.create(name: 'Test User', email: 'test@example.com', password: 'password123') }

    it 'is active by default' do
      expect(user.active?).to be true
    end

    it 'can be deactivated' do
      user.deactivate!
      expect(user.active?).to be false
    end

    it 'tracks last login timestamp' do
      expect {
        user.record_login!
      }.to change { user.last_login_at }
    end
  end
end
# helped by cursor