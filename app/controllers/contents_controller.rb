class ContentsController < ApplicationController
  before_action :authorize

  def new
    flash.notice = 'POST CONTENT'
    render_in_modal('contents/content_new.html.haml')
  end

  def create
    @relationship = Relationship.find_by(account_id: contents_params[:account],
                                    user_id: contents_params[:content_user_id])
    if @relationship
      params = {account_id: contents_params[:account],
                user_id: contents_params[:content_user_id],
                content_text: contents_params[:content_text],
                relationship_id: @relationship.id}
      if (Content.new(params)).save!
        flash.notice = 'Content Posted'
      else
        flash.notice = 'Content Save Failed'
      end
    else
      flash.notice = "Base Relationship doesn't exist for account/user"
    end
    # Hits views/contents/create.js.erb
  end

  def index
    @contents = [] # For now
  end

  private

  def contents_params
    params.require(:content).permit(:content_text, :account, :user_name,
                                    :content_user_name, :content_user_id)
  end
end
