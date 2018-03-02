class AccountsController < ApplicationController
  before_action :authorize
  # after_action { flash.discard if request.xhr? }, only: :create, :invited, :selected

  def new
    render_in_modal('accounts/acct_new')
  end

  def create
    user = current_user
    if (account = Account.create(accounts_params))
      flash.notice = 'Acct Saved'
      if Relationship.create(user_id: user.id,
                             relationship_type: 'owner',
                             account_id: account.id)
        session[:account_id] = account.id
        flash.notice = 'Relationship saved'
      else
        flash.notice = 'Relationship save failed'
      end
    else
      flash.notice = 'Acct Save Failed'
    end
  end

  def invite
    @accounts = Account.all
    @user = User.find(session[:user_id])
    render_in_modal('accounts/acct_invite')
  end

  def invited
    user_id = accounts_params[:user]
    account_id = accounts_params[:account]
    if Relationship.create(user_id: user_id,
                           relationship_type: 'member',
                           account_id: account_id)
      session[:account_id] = accounts_params[:account_id]
      flash.notice = 'member Relationship saved'
    else
      flash.notice = 'member Relationship save failed'
    end
  end

  def select
    @accounts = Account.all
    render_in_modal('accounts/acct_select')
  end

  def selected
    flash.notice = "selected account #{accounts_params[:account]}"
    session[:account_id] = accounts_params[:account]
    @contents = Content.where(account_id: accounts_params[:account])
                       .order(created_at: :desc)
  end

  def index
    @accounts = Account.all
  end

  private

  def accounts_params
    params.require(:account).permit(:name, :account, :user)
  end
end
