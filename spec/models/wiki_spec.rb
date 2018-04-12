require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { build(:wiki, user: user) }

  # Shoulda tests for associations
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:collaborators) }
  it { is_expected.to have_many(:collaborating_users).through(:collaborators).source(:user) }

  # Shoulda tests for title
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }

  # Shoulda tests for body
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  describe "attributes" do
    it "has title, body, private, and user attributes" do
      expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, private: wiki.private, user: wiki.user)
    end
  end

  describe "invalid wiki" do
    let(:invalid_wiki_title) { build(:wiki, title: "Abcd") }
    let(:invalid_wiki_body) { build(:wiki, body: "A short body") }

    it "should invalidate wiki for a title too short" do
      expect(invalid_wiki_title).to_not be_valid
    end

    it "should invalidate wiki for a body too short" do
      expect(invalid_wiki_body).to_not be_valid
    end
  end
end
