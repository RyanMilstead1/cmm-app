require 'rails_helper'

RSpec.describe WikiPolicy do
  let(:user) { create(:user) }
  let(:premium_user) { create(:user, role: :premium) }
  let(:admin) { create(:user, role: :admin) }
  let(:col_user) { create(:user) }

  let(:wiki) { create(:wiki, user: user) }
  let(:private_wiki) { create(:wiki, user: premium_user, private: true) }

  subject { described_class }

  permissions :index?, :show? do
    it "allows all users to view index and show for public wikis" do
      expect(subject).to permit(user, wiki)
      expect(subject).to permit(nil, wiki)
    end
  end

  permissions :show? do
    it "does not allow unauthorized users from viewing private wikis" do
      expect(subject).to_not permit(user, private_wiki)
    end

    it "does allow admin users to view private wikis" do
      expect(subject).to permit(admin, private_wiki)
    end

    it "does allow premium users to view private wikis" do
      expect(subject).to permit(premium_user, private_wiki)
    end

    it "does allow collaborators to view private wikis" do
      new_wiki = create(:wiki, user: user, private: true)
      new_wiki.collaborators.build(user: col_user)
      expect(subject).to permit(col_user, new_wiki)
    end
  end

  permissions :edit?, :update? do
    it "allows any user to edit a wiki" do
      expect(subject).to permit(user, wiki)
    end

    it "does not allow a non-user to edit a wiki" do
      expect(subject).to_not permit(nil, wiki)
    end

    it "does allow admin to edit a private wiki" do
      expect(subject).to permit(admin, private_wiki)
    end

    it "does allow premium users to edit a private wiki" do
      expect(subject).to permit(premium_user, private_wiki)
    end

    it "does not allow an unauthorized user to edit private wiki" do
      expect(subject).to_not permit(user, private_wiki)
    end
  end

  permissions :new?, :create? do
    it "allows any user to create a wiki" do
      expect(subject).to permit(user, wiki)
    end

    it "does not allow a non-user to create a wiki" do
      expect(subject).to_not permit(nil, wiki)
    end
  end

  permissions :destroy? do
    it "allows only admin and post creators to delete a wiki" do
      expect(subject).to permit(user, wiki)
      expect(subject).to permit(admin, wiki)
    end

    it "does not allow a non-user or other user to delete a wiki" do
      expect(subject).to_not permit(premium_user, wiki)
      expect(subject).to_not permit(nil, wiki)
    end
  end
end
