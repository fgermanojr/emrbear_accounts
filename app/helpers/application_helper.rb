module ApplicationHelper
  # def logged_in_as  # REMOVE
  #   current_user.try(:name)
  # end

  def current_account_display
    current_account.nil? ? '' : current_account.name
  end

  def current_user_display
    display = current_user.nil? ? '' : current_user.name
    session[:is_visitor] ? 'Visitor' : display
  end

  # def logged_in_as_html  # REMOVE
  #   if current_user
  #     "Signed in as " + current_user.name
  #   elsif session[:is_visitor]
  #     'Visitor'
  #   end
  # end
end
