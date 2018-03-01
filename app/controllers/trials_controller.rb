class TrialsController < ApplicationController
  before_action :authorize

  # This controller puts up modal dialog boxes;
  # should move these actions into respective controllers.  *****

  # def new
  #   flash.notice = 'NEW'
  #   render_in_modal('layouts/user_login')
  # end

  # def user_login
  #   flash.notice = 'USER_LOGIN'
  #   render_in_modal('layouts/user_login')
  # end

  # def user_logout
  #   render_in_modal('layouts/user_logout')
  # end

  # def user_verify
  #   render_in_modal('layouts/user_verify')
  # end

  # def user_create   # DOMNE
  #   flash.notice = 'USER CREATE'
  #   render_in_modal('layouts/user_create')
  # end

  def some_partial
    # Used for testing.
    render_in_modal('layouts/some_partial')
  end

  private

  def trials_params
    params.require(:trial).permit(:anything)
  end
end
