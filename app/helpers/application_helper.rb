module ApplicationHelper
  def current_account_display
    current_account.nil? ? 'No Current Account' : current_account.name
  end

  def current_user_display
    display = current_user.nil? ? '' : current_user.name
    session[:is_visitor] ? 'Visitor' : display
  end

  def accounts_for_select
    current_user.accounts.collect { |a| [ a.name, a.id ] }
  end

  def is_user_account_owner?(user, account)
    user.relationships.any? do |r|
      r.relationship_type == 'owner' &&
      user.id == r.user_id &&
      r.account_id == account.id
     end
  end

  def is_user_logged_in?(user)
    !current_user.nil? && user.name == current_user.name
  end

  def annotate_user(user)
    user_name = user.name
    user_name += '(current user)' if is_user_logged_in?(user)
    user_name += ':'
  end

  def annotate_account(user, account)
    account_name = account.name
    account_name += '(owner)' if is_user_account_owner?(user, account)
    account_name += ','
  end
end
