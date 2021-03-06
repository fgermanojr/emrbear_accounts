class ContentsController < ApplicationController
  before_action :authorize

  def new
    flash.notice = 'POST CONTENT'
    if is_visitor?
      flash.notice = "No account selected: either create or become invited"
      render template: '/layouts/access_denied' and return
    else
      render_in_modal('contents/content_new')
    end
  end

  def create
    if contents_params[:account].nil?  # not a owner or member of any accounts
                                       # so picker is empty
      flash.notice = "No account selected: either create or become invited"
      render template: '/layouts/access_denied' and return
    end
    context = determine_context(contents_params[:account],
                                contents_params[:content_user_id],
                                nil)

    if role_manager.permitted?(:post_content, context)
      # MOVE @r above if. extend if to include @r, if nil, not owner or member of anything
      @relationship = Relationship.find_by(account_id: contents_params[:account],
                                           user_id: contents_params[:content_user_id])

      params = set_up_create_params(contents_params, @relationship)
      content = Content.new(params)
      if (content.save)
        @content = Content.find(content.id)
        # The render partial will use @content
        puts content.errors.full_messages
        flash.notice = 'Content posted'
      else
        puts content.errors.full_messages
        flash.notice = 'Content save failed'
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
      # We need to put this form out to get invitee account
      # and then see if editable in the edit section; we can't do
      @content = Content.find(params[:id])
      render_in_modal('contents/content_edit', args: @content)
    end
  end

  def update
    flash.notice = 'UPDATE CONTENT'
    @content = Content.find(params[:id])

    if !is_visitor? && is_content_editable?(@content)
      update_params = set_up_update_params(contents_params)
      if Content.update(@content.id, update_params)
        flash.notice = "Content updated"
      else
        flash.notice = "Update save failed"
      end
    else
      # should never hit this unless someone is cheating; is caught at edit action.
      flash.notice = "Only owner's of private content can update" # TBD also not visitors
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
        # Visitors cannot see private content; the display subsystem doesn't show it.
        # If they can;t see it they can;t edit it;
        # Nevertheless, in update we check permissions incase they play with url
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
                                    :content_private, :content_account_id,
                                    :account_name, :private)
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

  def is_content_owner?(content)
    # Is the current user the owner of the content?
    return false if current_user.nil? # Visitor can't own any content
    content.relationship.user_id ==  current_user.id
  end


  def is_content_editable?(content)
    # The current user may not be owner or member of account;
    # in this case he cannot edit
    user_id = contents_params[:content_user_id]
    account_id = contents_params[:content_account_id]

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
