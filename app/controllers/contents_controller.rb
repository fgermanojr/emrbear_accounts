class ContentsController < ApplicationController
  before_action :authorize

  def new
    flash.notice = 'POST CONTENT'
    render_in_modal('contents/content_new.html.haml')
  end

  def create

    flash.notice = 'Content Posted X'
  # Hits views/contents/create.js.erb
  end

  def index
    @contents = [] # For now
  end

  private

  def contents_params
    params.require(:content).permit(:content_text)
  end
end
