class ContentsController < ApplicationController
  before_action :authorize

  def new
    flash.notice = 'POST CONTENT'
    render_in_modal('contents/content_new')
  end

  def create
    @relationship = Relationship.find_by(account_id: contents_params[:account],
                                    user_id: contents_params[:content_user_id])
    if @relationship
      params = {account_id: contents_params[:account],
                user_id: contents_params[:content_user_id],
                content_text: contents_params[:content_text],
                private: (contents_params[:content_private] == "1" ? true : false),
                relationship_id: @relationship.id}
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
      flash.notice = "Base Relationship doesn't exist for account/user"
    end
    # Hits views/contents/create.js.erb
  end

  def edit
    flash.notice = 'EDIT CONTENT'
    @content = Content.find(params[:id])
    render_in_modal('contents/content_edit', args: @content)
  end

  def update
    puts 'reached update'
    @content = Content.find(params[:id])
  end

  def index
    account_id = session[:account_id]
    if account_id.nil?
      flash.notice = "Set an Account context"
      @contents = []
    else
      @contents = Content.where(account_id: account_id).order(created_at: :desc)
    end
    # Need to filter out content that he should not see. RoleManager should do.
    # will need to filter on a per content basis to exclude private content.
  end

  private

  def contents_params
    params.require(:content).permit(:content_text, :account, :user_name,
                                    :content_user_name, :content_user_id,
                                    :content_private)
  end
end
