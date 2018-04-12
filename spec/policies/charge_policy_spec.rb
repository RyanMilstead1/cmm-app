require 'rails_helper'

RSpec.describe ChargePolicy do
  let(:premium) { create(:user, role: :premium) }
  let(:admin) { create(:user, role: :admin) }
  let(:standard) { create(:user) }

  subject { described_class }

  permissions :destroy? do
    it "allows users with premium" do
      expect(subject).to permit(premium)
    end

    it "does not allow standard and admin users" do
      expect(subject).to_not permit(admin)
      expect(subject).to_not permit(standard)
    end
  end

  permissions :create? do
    it "allows users with standard" do
      expect(subject).to permit(standard)
    end

    it "does not allow standard and admin users" do
      expect(subject).to_not permit(admin)
      expect(subject).to_not permit(premium)
    end
  end

  permissions :new? do
    it "allows users with standard" do
      expect(subject).to permit(standard)
    end

    it "does not allow standard and admin users" do
      expect(subject).to_not permit(admin)
      expect(subject).to_not permit(premium)
    end
  end
end
