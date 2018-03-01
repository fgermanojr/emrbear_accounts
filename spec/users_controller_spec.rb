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
      # response should be create.js.erb
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
end