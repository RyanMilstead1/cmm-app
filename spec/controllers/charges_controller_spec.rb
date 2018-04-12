require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:user) { create(:user, role: :premium) }
  let(:wiki) { create(:wiki, user: user, private: true) }

  describe "DELETE destroy" do
    before do
      sign_in user
    end

    it "redirects to wiki#index" do
      delete :destroy, params: {id: user.id}
      expect(response).to redirect_to(wikis_path)
    end

    it "converts user to a standard status after downgrading" do
      expect(user.premium?).to be_truthy
      delete :destroy, params: {id: user.id}
      user.reload
      expect(user.standard?).to be_truthy
    end

    it "converts all private wikis to public when premium user downgrades" do
      expect(wiki.private).to be_truthy
      delete :destroy, params: {id: user.id}
      wiki.reload
      expect(wiki.private).to be_falsey
    end
  end
end
