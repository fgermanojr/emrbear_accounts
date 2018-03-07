class ContentsController < ApplicationController
  before_action :authorize

  def new
    flash.notice = 'POST CONTENT'
    # TBD SHOULD BE permitted? here for visitor
    render_in_modal('contents/content_new')
  end

  def create
    context = determine_context(contents_params[:account],
                                contents_params[:content_user_id],
                                nil)
    if role_manager.permitted?(:post_content, context)
      @relationship = Relationship.find_by(account_id: contents_params[:account],
                                           user_id: contents_params[:content_user_id])
      params = set_up_create_params(contents_params, @relationship)
      content = Content.new(params)
      if (content.save)
        @content = Content.find(content.id)
        # The render partial will use @content
        puts content.errors.full_messages
        flash.notice = 'Content Posted'
      else
        puts content.errors.full_messages
        flash.notice = 'Content Save Failed'
      end
    else
      @content = nil
      flash.notice = "Content operation '#{:post_content.to_s}' not permitted"
      render template: '/layouts/access_denied' and return
    end
    # Hits views/contents/create.js.erb
  end

  def edit
    flash.notice = 'EDIT CONTENT'
    if is_visitor?
      flash.notice = "Visitor's can't edit content"
      render template: '/layouts/access_denied' and return
    else
      # We need to put this form out to get invitee account and then see if editable
      @content = Content.find(params[:id])
      if is_content_editable?(@content)
        render_in_modal('contents/content_edit', args: @content)
      end
    end
  end

  def update
    flash.notice = 'UPDATE CONTENT'
    @content = Content.find(params[:id])
    if contents_params[:content_user_id].nil? || contents_params[:content_account_id].nil?
      flash.notice = "Visitor's can't update content"
      render template: '/layouts/access_denied' and return
    end

    if is_content_editable?(@content)
      update_params = set_up_update_params(contents_params)
      if @content.update(@content.id, update_params)
        flash.notice = "Content updated"
      else
        flash.notice = "Update save failed"
      end
    else
      # should never hit this unless someone is cheating; is caught at edit action.
      flash.notice = "Visitor's can't edit content"
      render template: '/layouts/access_denied' and return
    end
  end

  def index
    account_id = session[:account_id]
    if account_id.nil?
      flash.notice = "Set an Account context"
      # TBD ? CONSIDER PUTTING UP account_select
      @contents = []
    else
      if is_visitor? # TBD should this go thru role_manager
        # Visitors cannot see private content.
        # If they can;t see it they can;t edit it; so they can;t reach directly.
        # The update checks are a further check against tampering
        @contents = Content.where(account_id: account_id, private: false).order(created_at: :desc)
      else
        @contents = Content.where(account_id: account_id).order(created_at: :desc)
      end
    end
  end

  private

  def contents_params
    params.require(:content).permit(:content_text, :account, :user_name,
                                    :content_user_name, :content_user_id,
                                    :content_private, :content_account_id)
  end

  def is_content_owner?(content)
    # Is the current user the owner of the content
    content.relationship.user_id ==  current_user
  end

  def set_up_create_params(contents_params, relationship)
    {
      account_id: contents_params[:account],
      user_id: contents_params[:content_user_id],
      content_text: contents_params[:content_text],
      private: (contents_params[:content_private] == "1" ? true : false),
      relationship_id: relationship.id
    }
  end

  def set_up_update_params(contents_params)
    {
      content_text: contents_params[:content_text],
      private: (contents_params[:content_private] == "1" ? true : false)
    }
  end

  def is_content_editable?(content)
    user_id = content.relationship.user_id
    account_id = content.relationship.account_id

    context = determine_context(account_id, user_id, is_content_owner?(content))
    if content.private
      permitted = role_manager.permitted?(:edit_private_content, context)
      if !permitted
        flash.notice = "Only owner's of private content can edit it"
      end
    else
      permitted = role_manager.permitted?(:edit_public_content, context)
      if !permitted
        flash.notice = "Only creator or invitee of account can edit public content"
      end
    end
    permitted
  end
end
