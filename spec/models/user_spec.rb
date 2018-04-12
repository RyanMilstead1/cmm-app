require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  # Shoulda test for associations
  it { is_expected.to have_many(:wikis) }
  it { is_expected.to have_many(:collaborating_on).through(:collaborators).source(:wiki) }
  it { is_expected.to have_many(:collaborators) }

  # Shoulda test for emails
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to allow_value("dave@unique.io").for(:email)}

  # Shoulda test for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  # Shoulda test for username
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_least(1) }
  it { is_expected.to validate_length_of(:username).is_at_most(30) }

  describe "attributes" do
    it "has email and username attribute" do
      expect(user).to have_attributes(email: user.email, username: user.username)
    end
  end

  describe "invalid user" do
    let(:invalid_user_email) { build(:user, email: "") }
    let(:invalid_user_username) { build(:user, username: "") }

    it "should be an invalid user for a blank email" do
      expect(invalid_user_email).to_not be_valid
    end

    it "should be an invalid user for a blank username" do
      expect(invalid_user_username).to_not be_valid
    end
  end

  describe "roles" do
    it "is standard by default" do
      expect(user.role).to eq("standard")
    end

    context "standard" do
      it "returns true for #standard?" do
        expect(user.standard?).to be_truthy
      end

      it "returns false for #admin? or #premium?" do
        expect(user.admin?).to be_falsey
        expect(user.premium?).to be_falsey
      end
    end

    context "premium" do
      before do
        user.premium!
      end

      it "returns true for #premium?" do
        expect(user.premium?).to be_truthy
      end

      it "returns false for #admin? or #standard?" do
        expect(user.admin?).to be_falsey
        expect(user.standard?).to be_falsey
      end
    end

    context "admin" do
      before do
        user.admin!
      end

      it "returns true for #admin?" do
        expect(user.admin?).to be_truthy
      end

      it "returns false for #premium? or #standard?" do
        expect(user.premium?).to be_falsey
        expect(user.standard?).to be_falsey
      end
    end
  end
end
