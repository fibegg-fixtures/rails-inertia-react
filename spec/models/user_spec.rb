require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with email + password" do
    expect(build(:user)).to be_valid
  end

  it { should validate_presence_of(:email) }
  it { should have_secure_password }
end
