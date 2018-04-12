require 'rails_helper'

RSpec.describe Collaborator, type: :model do
  let(:user) { create(:user) }
  let(:wiki) { create(:wiki) }
  let(:collaborator) { create(:collaborator, user: user, wiki: wiki) }

  # Shoulda test for associations
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:wiki) }
end
