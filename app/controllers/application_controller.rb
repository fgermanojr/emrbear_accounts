class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user  # TBD NEED TO FIX UP FOR VISITOR
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user # make the controller method available in view

  def current_account
    Account.find(session[:account_id]) if session[:account_id]
  end
  helper_method :current_account

  def authorize
    return if current_user
    flash.notice = "Login, or continue as Visitor"
  end

  def establish_session(new_user, is_visitor)
    if is_visitor
      session[:user_id] = nil
      session[:name] = nil
      session[:email] = nil
      session[:logged_in] = nil
    else
      session[:user_id] = new_user.id
      session[:name] = new_user.name
      session[:email] = new_user.email
      session[:logged_in] = true
    end
  end

  def establish_account_in_session(account_id)
    session[:account_id] = account_id
  end

  def is_admin?
    # I am the only admin so we just 'hardwire' this fact
    # If there is no current user, there is no admin, so returns false
    current_user.email == 'fgermano@earthlink.net' if current_user
  end
  helper_method :is_admin?

  def is_visitor?
    session[:user_id].nil?
  end
  helper_method :is_visitor?

  # Usage: render_in_modal('relative_to_views/some_partial')
  def render_in_modal(partial, args={})
    render template: 'layouts/ajax_modal', locals: {partial: partial, args: args}, formats: [:js]
  end

  def role_manager
    @rm ||= RoleManager::RoleManager.new()
  end

  def determine_context(account_id, user_id, is_content_owner)
    is_owner = is_member = is_visitor = is_user = nil
    if account_id.present? && user_id.present?
      @relationship = Relationship.find_by(account_id: account_id, user_id: user_id)
      if @relationship
        if @relationship.relationship_type == 'owner'
          is_owner = true
        elsif @relationship.relationship_type == 'member'
          is_member = true
        else
          fail 'INVALID relationship type'  # should not happen
        end
      end
    end
    is_user = true if session[:user_id]
    is_visitor = true if session[:user_id].nil?
    context = [is_visitor, is_user, is_member, is_owner, is_content_owner]
    context
  end
end
