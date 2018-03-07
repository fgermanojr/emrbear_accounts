require 'rails_helper'

RSpec.describe ContentsController, type: :controller do
  render_views # This is optional
  # establish_session is defined by me in rails_helper.rb CHECK

  # By default, until we log in, we are a visitor.
  # Add test for visitor create/new (no need to show form);
  #   so we can disallow like edit and not show form. TBD
  # TBD what application_controller methods can be tested
  describe "visitor protected actions" do
    let!(:account_master_user_frank_owner) do
      create(:relationship, :account_master_user_frank_owner)
    end
    let(:account) { Account.find_by(name: "AccountMaster") }
    let(:user) { User.find_by(name: 'frank') }
    let(:content) { Content.create(account_id: account.id, user_id: user.id,
                                   relationship: Relationship.all.first,
                                   content_text: 'text', private: false) }
    let(:contents_params) { { id: content.id, content: { content_text: 'public content', private: false } } }

    it "visitor can't post content" do
      post :create, xhr: true, params: contents_params
      expect(flash[:notice]).to match(/not permitted/)
    end

    it "visitor can't edit content" do
      get :edit, xhr: true, params: {id: content.id}
      expect(flash[:notice]).to match(/can't edit/)
    end

    it "visitor can't update content" do
      # In production this end point can;t be hit without tampering
      contents_params[:user_id] = nil
      put :update, xhr: true, params: contents_params
      expect(flash[:notice]).to match(/can't update/)
    end

    # it "visitor can't create account" do TBD
    # end
  end

  describe "user protected actions" do

    # TRY TO ADD inner describe, each with own lets.
    # test 1 data
    # User frank
    # Account AccountMaster
    # Relationship owner

    let!(:account_master_user_frank_owner) do
      create(:relationship, :account_master_user_frank_owner)
    end
    let(:account_master) { Account.find_by(name: "AccountMaster") }
    let(:user_frank) { User.find_by(name: 'frank') }
    let(:content_master_frank) do
      Content.create(account_id: account_master.id,
                     user_id: user_frank.id,
                     relationship: Relationship.all.first,  # replace with account_master_user_frank_owner
                     content_text: 'text', private: false)
    end
    let(:contents_master_frank_public_params) do
      { id: content_master_frank.id,
        content: { content_text: 'public content', private: false } }
    end

    # test 2 data
    # User jen
    # Account AccountDetail
    # Relationship owner

    let!(:account_detail_user_jen_member) do
       create(:relationship, :account_detail_user_jen_owner)
    end

    let(:account_detail) { Account.find_by(name: "AccountDetail") }
    let(:user_jen) { User.find_by(name: 'jen') }
    let(:jen_post_content_to_master_params) do # will fail because jen not member or owner
      { account_id: account_master.id, user_id: user_jen.id,
        relationship_id: nil,
        content: { content_text: 'public content', private: false } }
    end
    let(:jen_post_content_to_detail_params) do # will pass because jen is owner
      { account_id: account_master.id, user_id: user_jen.id,
        relationship_id: nil,
        content: { content_text: 'public content', private: false } }
    end

    # test 3 data
    # User tess
    # Account AccountMaster
    # Relationship member

    let!(:account_favorite_user_tess_member) do
       create(:relationship, :account_favorite_user_tess_member)
    end
    let(:user_tess) { User.find_by(name: 'tess') }
    let(:account_favorite) { Account.find_by(name: 'AccountFavorite') }
    let(:tess_post_content_to_master_params) do
      { account_id: account_favorite.id,
        user_id: user_tess.id,
        relationship_id: account_favorite_user_tess_member.id,
        content: { content_text: 'private content', private: true } }
    end

    it "01-user can't post to account unless owner" do # passes
      # jen cant post to master because she is not owner or member
      establish_session(user_jen, false) # "log in as jen"
      post :create, xhr: true, params: jen_post_content_to_master_params
      expect(flash[:notice]).to match(/not permitted/)
    end

    it "02-user can post to account as owner" do # passes
      # jen can post to detail because she is owner
      establish_session(user_jen, false) # "log in as jen"
      post :create, xhr: true, params: jen_post_content_to_detail_params
      expect(flash[:notice]).to match(/not permitted/)
    end

    it "03-user can post to account if member" do # passes
      # tess can post to master because she is member
      establish_session(user_tess, false) # "log in as tess"
      post :create, xhr: true, params: tess_post_content_to_master_params
      expect(flash[:notice]).to match(/not permitted/)
    end

    # issue of posting content to relationship_type owner vs member instance of relationship;
    #   TBD what is being done in code now? What should it be? If owner post to owner, if member post to member?
    # I think that should be the rule and work? I believe it is waht we are doing. check

    # it "user can create private content if owner or member" do

    # end

    # it "user can create public content if owner or member" do

    # end

    # it "user can edit private content if content owner" do

    # end

    # it "user can't edit private content if not content owner" do

    # end
  end
end