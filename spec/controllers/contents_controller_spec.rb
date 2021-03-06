require 'rails_helper'

RSpec.describe ContentsController, type: :controller do
  render_views # This is optional
  # By default, until we log in, we are a visitor.

  describe "visitor protected actions" do
    let!(:account_master_user_frank_owner) do
      create(:relationship, :account_master_user_frank_owner)
    end
    let(:account) { Account.find_by(name: "AccountMaster") }
    let(:user) { User.find_by(name: 'frank') }
    let(:content) { Content.create(account_id: account.id, user_id: user.id,
                                   relationship: account_master_user_frank_owner,
                                   content_text: 'text', private: false) }
    let(:contents_params) { { id: content.id, content: { content_text: 'public content', private: false } } }

    it "visitor can't post content" do
      session[:account_id] = account.id   # Visitor has the ability to set account context
      post :create, xhr: true, params: contents_params
      expect(flash[:notice]).to match(/No account selected/)
    end

    it "visitor can't edit content" do
      get :edit, xhr: true, params: {id: content.id}   # CHECK THIS PATH
      expect(flash[:notice]).to match(/can't edit/)
    end

    it "visitor can't update content" do
      # In production this end point can;t be hit without tampering
      contents_params[:user_id] = nil
      put :update, xhr: true, params: contents_params
      expect(flash[:notice]).to match(/Only owner's/)
    end
  end

  describe "user protected actions" do
    describe "01-user can post to account if owner" do #passes
      # User frank
      # Account AccountMaster
      # Relationship owner

      let!(:account_master_user_frank_owner) do
        create(:relationship, :account_master_user_frank_owner)
      end

      let(:account_master) { Account.find_by(name: "AccountMaster") }
      let(:user_frank) { User.find_by(name: 'frank') }

      let(:frank_post_content_to_master_params) do
        {
          content: { account: account_master.id,
                     content_text: 'private content',
                     content_user_id: user_frank.id,
                     private: true }
        }
      end

      it "user can post to account if owner" do
        # frank can post to master because he is owner
        establish_session(user_frank, false)
        post :create, xhr: true, params: frank_post_content_to_master_params
        expect(flash[:notice]).to match(/Content posted/)
      end
    end

    describe "02-user can't post to account if not member" do # passes
      # User jen
      # Account AccountDetail
      # Relationship none

      let(:account_master) { create(:account, :account_master) }
      let(:user_jen) { create(:user, :user_jen) }

      let(:jen_post_content_to_master_params) do
        {
          content: {
            account: account_master.id,
            content_user_id: user_jen.id,
            content_text: 'public content',
            private: false
          }
        }
      end

      it "user can't post to account if not member" do
        # jen can post to detail because she is owner
        establish_session(user_jen, false) # "log in as jen"
        post :create, xhr: true, params: jen_post_content_to_master_params
        expect(flash[:notice]).to match(/not permitted/)
      end
    end

    describe "03-user can post to account if member" do
      # test 3 data
      # User tess
      # Account AccountMaster
      # Relationship member

      let!(:account_favorite_user_tess_member) do
         create(:relationship, :account_favorite_user_tess_member)
      end
      let(:user_tess) { User.find_by(name: 'tess') }
      let(:account_favorite) { Account.find_by(name: 'AccountFavorite') }
      let(:tess_post_content_to_favorite_params) do
        { content:
          { account: account_favorite.id,
            content_user_id: user_tess.id,
            content_text: 'private content',
            private: true
          }
        }
      end
      let(:tess_private_content_for_edit) do
        create(:content, :private_for_edit,
          { user_id: user_tess.id,
            account_id: account_favorite.id,
            relationship_id: account_favorite_user_tess_member.id
          }
        )
      end
      let(:tess_edit_favorite_params) do
        { id: tess_private_content_for_edit,
          content: {content_text: 'new content'}
        }
      end
      let(:user_frank) {create(:user, :user_frank)}
      let(:frank_edit_favorite_params) do # frank trying to edit tess's content
        { id: tess_private_content_for_edit,
          content: {content_text: 'new content'}
        }
      end

      it "user can post to account if member" do # passes
        # tess can post to favorite because she is member
        establish_session(user_tess, false)
        post :create, xhr: true, params: tess_post_content_to_favorite_params
        expect(flash[:notice]).to match(/Content posted/)
      end

      it "user can edit private content if owner of content" do # passes
        establish_session(user_tess, false)
        post :update, xhr: true, params: tess_edit_favorite_params
        expect(flash[:notice]).to match(/Content updated/)
      end

      it "user can't edit private content if not content owner" do # passes  FAILING
        establish_session(user_frank, false)
        session[:account_id] = account_favorite.id
        post :update, xhr: true, params: frank_edit_favorite_params
        expect(flash[:notice]).to match(/Only owner's/)
      end
    end
  end
end