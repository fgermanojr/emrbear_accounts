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

    it "renders index view with User List" do
      get :index
      expect(response.body).to include("User")
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