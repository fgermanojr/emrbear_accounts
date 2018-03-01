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
end