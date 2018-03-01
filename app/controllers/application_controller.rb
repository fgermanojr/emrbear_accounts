class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user  # TBD NEED TO FIX UP FOR VISITOR
    # @current_user ||= User.find(session[:user_id]) if session[:user_id]
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user # make the controller method available in view

  def current_account
    # @current_account ||= Account.find(session[:account_id]) if session[:account_id]
    Account.find(session[:account_id]) if session[:account_id]
  end
  helper_method :current_account

  def authorize
    return if current_user
    flash.notice = "Please Login"
  end

  def establish_session(new_user, is_visitor)
    session[:user_id] = new_user.id
    session[:name] = new_user.name
    session[:email] = new_user.email
    session[:logged_in] = true
    session[:is_visitor] = true if is_visitor
    flash.notice = 'Sessioned'
  end

  def is_admin?
    # I am the only admin so we just 'hardwire' this fact
    # If there is no current user, there is no admin, so returns false
    current_user.email == 'fgermano@earthlink.net' if current_user
  end
  helper_method :is_admin?

  # Usage: render_in_modal('relative_to_views/some_partial')
  def render_in_modal(partial, args={})
    render template: 'layouts/ajax_modal', locals: {partial: partial, args: args}, formats: [:js]
  end
end
