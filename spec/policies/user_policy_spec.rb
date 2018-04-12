require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  subject { described_class }

  permissions :show? do
    it "allows users to edit their own profile" do
      expect(subject).to permit(user, user)
    end

    it "does not allow standard and admin users" do
      expect(subject).to_not permit(other_user, user)
    end
  end
end
