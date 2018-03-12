require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  render_views # This is optional;

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
      expect(response.body).to include("Created")
    end

    it "sets the user state in session" do
      post :create, xhr: true, params: users_params
      expect(session[:name]).to eql('Frank Germano')
      expect(session[:email]).to eql('frank@germano.org')
      expect(session[:logged_in]).to be true
    end

    it "sets the flash" do
      post :create, xhr: true, params: users_params
      expect(flash[:notice]).to match(/Created/)
    end
  end

  # TBD move this test to model
  describe "test fixture account" do
    let!(:account_master) { create(:account, :account_master) }
    it "has correct name" do
      expect(account_master.name).to eql("AccountMaster")
    end
  end

  # By default, until we log in, we are a visitor.
  describe "visitor actions" do
    let!(:account_master_user_frank_owner) do
      create(:relationship, :account_master_user_frank_owner)
    end
    let(:account) { Account.find_by(name: "AccountMaster") }
    let(:accounts_params) { { account: { account: account } } }

    it "visitor can't invite" do
      post :invite, xhr: true, params: accounts_params
      expect(flash[:notice]).to match(/cannot invite/)
    end
  end

  describe "user actions" do
    let(:user_fred) {create(:user, :user_fred)}
    let(:new_account_params) do
      { account: { name: 'new_account', user: user_fred } }
    end

    it "user can create new account" do
      establish_session(user_fred, false)
      post :create, xhr: true, params: new_account_params
      expect(flash[:notice]).to match(/Relationship saved/)
    end
  end
end