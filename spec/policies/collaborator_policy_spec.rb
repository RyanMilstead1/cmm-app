require 'rails_helper'

RSpec.describe CollaboratorPolicy do
  let(:owner) { create(:user, role: :premium) }
  let(:admin) { create(:user, role: :admin) }
  let(:standard) { create(:user) }

  let(:wiki) { create(:wiki, private: true, user: owner) }

  let(:collaborator) { create(:collaborator, wiki_id: wiki.id, user_id: owner.id) }

  subject { described_class }

  permissions :create? do
    it "allows admin to create collaborations" do
      expect(subject).to permit(admin, collaborator)
    end

    it "allows owner to create collaborations" do
      expect(subject).to permit(owner, collaborator)
    end

    it "denies standard access to create collaborations" do
      expect(subject).to_not permit(standard, collaborator)
    end
  end

  permissions :destroy? do
    it "allows admin to destroy a collaborator" do
      expect(subject).to permit(admin, collaborator)
    end

    it "allows owner to destroy a collaborator" do
      expect(subject).to permit(owner, collaborator)
    end

    it "does not allow standard user to destroy a collaborator" do
      expect(subject).to_not permit(standard, collaborator)
    end
  end
end
