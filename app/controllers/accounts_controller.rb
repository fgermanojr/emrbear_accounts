class AccountsController < ApplicationController
  before_action :authorize

  def new
    render_in_modal('accounts/acct_new')
  end

  def create
    user = current_user
    if (account = Account.create(accounts_params.except(:user)))
      flash.notice = 'Account Saved'
      if Relationship.create(user_id: user.id,
                             relationship_type: 'owner',
                             account_id: account.id)
        session[:account_id] = account.id
        flash.notice = 'Relationship saved'
      else
        flash.notice = 'Relationship save failed'
      end
    else
      flash.notice = 'Account Save Failed'
    end
  end

  def invite
    @accounts = Account.all
    # We need to render form to get account context.
    # TBD Should I pass this thru role manager
    if is_visitor?
      flash.notice = "Visitors cannot invite others"
      render_in_modal('layouts/access_denied')
    else
      @user = User.find(session[:user_id])
      render_in_modal('accounts/acct_invite')
    end
  end

  def invited
    invitee_user_id = accounts_params[:user]
    invited_to_account_id = accounts_params[:account]

    if can_current_user_invite_to_account?(current_user, invited_to_account_id)
      if Relationship.create(user_id: invitee_user_id,
                             relationship_type: 'member',
                             account_id: invited_to_account_id)
        establish_account_in_session(invited_to_account_id)
        flash.notice = 'Member relationship saved'
      else
        flash.notice = 'Member relationship save failed'
      end
    else
      flash.notice = 'Must be owner of account to Invite members.'
    end
  end

  def select
    @accounts = Account.all
    # user / visitor can see all accounts
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

  def can_current_user_invite_to_account?(user_id, account_id)
    context = determine_context(account_id, user_id, nil)
    role_manager.permitted?(:invite_to_account, context)
  end
end
