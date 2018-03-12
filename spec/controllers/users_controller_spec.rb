require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views # This is optional

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders index view" do
      get :index
      expect(response).to render_template(:index)
    end

    it "renders index view" do
      get :index
      expect(response.body).to include("User")
    end
  end

  describe "POST AJAX #create" do
    let(:users_params) { { user: {name: "Frank Germano", email: "frank@germano.org",
                           password: "foo", password_confirmation: "foo" } } }
    it "returns js fragment" do
      post :create, xhr: true, params: users_params
      # response is create.js.erb
      expect(response.body).to include("create.js.erb")
    end

    it "sets the user state in session" do
      post :create, xhr: true, params: users_params
      expect(session[:name]).to eql('Frank Germano')
      expect(session[:email]).to eql('frank@germano.org')
      expect(session[:logged_in]).to be true
    end

    it "sets the flash" do
      post :create, xhr: true, params: users_params
      expect(flash[:notice]).to match(/User created/)
    end
  end

  # TBD move to model
  describe "test fixture user" do
    let!(:user_frank) { create(:user, :user_frank) }
    it "has correct name" do
      expect(user_frank.name).to eql("Frank")
    end
  end

  describe "test fixture relationship" do
    # let!(:user_frank) { create(:user, :user_frank) }
    # let!(:account_master) { create(:account, :account_master) }
    let!(:account_master_user_frank_owner) do
      create(:relationship, :account_master_user_frank_owner)
    end

    it "creates relationship" do
      expect(account_master_user_frank_owner.relationship_type).to eql('owner')
    end
    it "creates relationship user frank" do
      expect(account_master_user_frank_owner.user.name).to eql('frank')
    end
    it "creates relationship account AccountMaster" do
      expect(account_master_user_frank_owner.account.name).to eql('AccountMaster')
    end
  end
end