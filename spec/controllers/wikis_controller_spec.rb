require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:wiki) { create(:wiki, user: user) }
  let(:other_wiki) { create(:wiki) }

  shared_examples_for User do
    describe "GET show" do
      it "returns http success" do
        get :show, params: {id: wiki.id}
        expect(response).to have_http_status(200)
      end

      it "renders the #show view" do
        get :show, params: {id: wiki.id}
        expect(response).to render_template(:show)
      end

      it "assigns wiki to @wiki" do
        get :show, params: {id: wiki.id}
        expect(assigns(:wiki)).to eq(wiki)
      end
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(200)
      end

      it "renders the #index view" do
        get :index
        expect(response).to render_template(:index)
      end

      it "assigns public wikis to @wiki" do
        wiki = create(:wiki)
        get :index
        expect(assigns(:wikis)).to eq([wiki])
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(200)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template(:new)
      end

      it "instantiates @wiki" do
        get :new
        expect(assigns(:wiki)).to_not be_nil
      end
    end

    describe "POST create" do
      it "increases the number of wikis by 1" do
        expect{post :create, params: {wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}}.to change(Wiki, :count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, params: {wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}
        expect(assigns(:wiki)).to eq(Wiki.last)
      end

      it "redirects to the new wiki" do
        post :create, params: {wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}
        expect(response).to redirect_to(Wiki.last)
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: {id: wiki.id}
        expect(response).to have_http_status(200)
      end

      it "renders the #edit view" do
        get :edit, params: {id: wiki.id}
        expect(response).to render_template(:edit)
      end

      it "assigns wiki to be udpated to @wiki" do
        get :edit, params: {id: wiki.id}
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq(wiki.id)
        expect(wiki_instance.title).to eq(wiki.title)
        expect(wiki_instance.body).to eq(wiki.body)
        expect(wiki_instance.private).to eq(wiki.private)
        expect(wiki_instance.user_id).to eq(wiki.user_id)
      end

      it "can edit a wiki from another user" do
        get :edit, params: {id: wiki.id}
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = Faker::Hacker.say_something_smart
        new_body = Faker::Hipster.paragraph
        new_private = false

        put :update, params: {id: wiki.id, wiki: {title: new_title, body: new_body, private: new_private}}
        updated_wiki = assigns(:wiki)

        expect(updated_wiki.id).to eq(wiki.id)
        expect(updated_wiki.title).to eq(new_title)
        expect(updated_wiki.body).to eq(new_body)
        expect(updated_wiki.private).to eq(new_private)
      end

      it "can update a wiki from another user" do
        new_title = Faker::Hacker.say_something_smart
        new_body = Faker::Hipster.paragraph
        new_private = false

        put :update, params: {id: other_wiki.id, wiki: {title: new_title, body: new_body, private: new_private}}
        updated_wiki = assigns(:wiki)

        expect(updated_wiki.id).to eq(other_wiki.id)
        expect(updated_wiki.title).to eq(new_title)
        expect(updated_wiki.body).to eq(new_body)
        expect(updated_wiki.private).to eq(new_private)
      end

      it "redirects to the updated wiki" do
        put :update, params: {id: wiki.id, wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}
        expect(response).to redirect_to(wiki)
      end
    end

    describe "DELETE destroy" do
      it "deletes a wiki owned by user" do
        delete :destroy, params: {id: wiki.id}
        expect(Wiki.where({id: wiki.id}).size).to eq(0)
      end

      it "redirects to wiki#index after deletion" do
        delete :destroy, params: {id: wiki.id}
        expect(response).to redirect_to(wikis_path)
      end
    end
  end

  context "guest" do
    before do
      sign_out user
    end

    describe "GET show" do
      it "is not accessible to unregistered user" do
        get :show, params: {id: wiki.id}
        expect(response).to be_redirect
      end
    end

    describe "GET index" do
      it "is not accessible to unregistered user" do
        get :index
        expect(response).to be_redirect
      end
    end

    describe "GET new" do
      it "is not accessible to unregistered user" do
        get :new
        expect(response).to be_redirect
      end
    end

    describe "POST create" do
      it "is not accessible to unregistered user" do
        post :create, params: {wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}
        expect(response).to be_redirect
      end
    end

    describe "GET edit" do
      it "is not accessible to unregistered user" do
        get :edit, params: {id: wiki.id}
        expect(response).to be_redirect
      end
    end

    describe "PUT update" do
      it "is not accessible to unregistered user" do
        put :update, params: {id: wiki.id, wiki: {title: Faker::Hacker.say_something_smart, body: Faker::Hipster.paragraph, private: false}}
        expect(response).to be_redirect
      end
    end

    describe "DELETE destroy" do
      it "is not accessible to unregistered user" do
        delete :destroy, params: {id: wiki.id}
        expect(response).to be_redirect
      end
    end
  end

  context "standard user" do
    before do
      sign_in user
    end

    it_behaves_like User

    describe "DELETE destroy" do
      it "cannot delete wiki it didn't create" do
        delete :destroy, params: {id: other_wiki.id}
        expect(Wiki.where({id: other_wiki.id}).size).to eq(1)
      end
    end

    describe "privacy" do
      let(:wiki_private) { create(:wiki, user: user, private: true) }

      it "should not let standard users create private wikis" do
        expect(wiki_private.private).to be_falsey
      end
    end
  end

  context "premium user" do
    before do
      user.premium!
      sign_in user
    end

    it_behaves_like User

    describe "DELETE destroy" do
      it "cannot delete wiki it didn't create" do
        delete :destroy, params: {id: other_wiki.id}
        expect(Wiki.where({id: other_wiki.id}).size).to eq(1)
      end
    end

    describe "privacy" do
      let(:wiki_private) { create(:wiki, user: user, private: true) }

      it "should let premium users create private wikis" do
        expect(wiki_private.private).to be_truthy
      end
    end
  end

  context "admin user" do
    before do
      user.admin!
      sign_in user
    end

    it_behaves_like User

    describe "DELETE destroy" do
      it "deletes a wiki owned by anyone" do
        delete :destroy, params: {id: other_wiki.id}
        expect(Wiki.where({id: other_wiki.id}).size).to eq(0)
      end
    end

    describe "privacy" do
      let(:wiki_private) { create(:wiki, user: user, private: true) }

      it "should let admin users create private wikis" do
        expect(wiki_private.private).to be_truthy
      end
    end
  end
end
