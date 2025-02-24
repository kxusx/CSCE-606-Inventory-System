require_relative '../rails_helper'

RSpec.describe Session, type: :model do
  let(:user) { User.create(email: "test@example.com", password: "password123") }

  it "is valid with a user and login_time" do
    session = Session.new(user: user, login_time: Time.current)
    expect(session).to be_valid
  end

  it "is invalid without a user" do
    session = Session.new(login_time: Time.current)
    expect(session).not_to be_valid
  end

  it "tracks logout time" do
    user = User.create!(name: "Test User", email: "test@example.com", password: "Password@123")
    session = Session.create(user: user, login_time: Time.current)
    session.update(logout_time: Time.current + 1.hour)
    expect(session.logout_time).not_to be_nil
  end
end
