class AccountsController < ApplicationController
  before_action :authorize

  def new
    render_in_modal('accounts/acct_new')
  end

  def create
    if Account.create(accounts_params)
      flash.notice = 'Acct Saved'
    else
      flash.notice = 'Acct Save Failed'
    end
  end

  def invite
    @accounts = Account.all
    @user = User.find(session[:user_id])
    render_in_modal('accounts/acct_invite')
  end

  # invite action, invited

  def select
    @accounts = Account.all
    render_in_modal('accounts/acct_select')
  end

  # select action, selected

  def index
    @accounts = Account.all
  end

  private

  def accounts_params
    params.require(:account).permit(:name)
  end
end
