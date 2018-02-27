class ContentsController < ApplicationController
  # before_action :authorize

  def new
    @content = Content.new()
  end

  def index
    @contents = [] # For now
  end
end
