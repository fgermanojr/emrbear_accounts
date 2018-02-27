# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  require 'securerandom'
  include MyHelpers

  # def new
  #   # puts up login form
  # end

  def login # process login
    user = check_user_exists
    verify_password(user)
  end

  # def edit
  #   # puts up token form
  # end

  def update # validate token   # renamed to verify
    user = check_user_exists  # token is stored with user
    flash.notice = "UPDATE"
    validate_entered_token(user, authentication_params[:token])
  end

  def logout
    flash.notice = "LOGGED OUT"
    reset_session
  end

  private

  def authentication_params
    params.require(:authenticate).permit(:email, :password, :token, :is_visitor)
  end

  def check_user_exists
    flash.notice = authentication_params[:email]
    user = User.find_by(email: authentication_params[:email])
    unless user
      flash.notice = 'User does not exist'
    end
    user
  end

  def verify_password(user)
    is_visitor = authentication_params[:is_visitor]
    if is_visitor == "1"
      establish_session(user, true)
    else
      command = authenticate_user_via_password
      if command.success?  # password is good
        use_2fa = true
        if use_2fa
          request_2fa_token(user)
        else
          establish_session(user, nil)
        end
      else
        flash.notice = 'Bad password'
      end
    end
  end

  def request_2fa_token(user)
    token = generate_token
    preserve_token(user, token)
    if send_token_via_email(user, token)
      # THIS NEEDS WORK
      # back around to allow user to enter token into token verify form
      # NEED TO TAKE FIRST ONE DOWN before this
      # render_in_modal('layouts/user_verify')
    else
      flash.notice = 'Token email send failed'
    end
  end

  def validate_entered_token(user, token)
    use_2fa = true
    if use_2fa
      if verify_token(user, token)
        establish_session(user, nil)
      else
        flash.notice = 'Bad token entered'
      end
    else
      establish_session(user, nil)
    end
  end

  def authenticate_user_via_password
    AuthenticateUser.call(authentication_params[:email],
                          authentication_params[:password])
  end

  def send_token_via_email(user, token)
    from = 'fgermano@earthlink.net'
    to = user.email
    subject = 'Emrbear Accounts Login Token Validation'
    msg = " Please enter token #{token} to complete login"
    send_mail_delayed(from, to, subject, msg)  # XXX Does this rtn true on success ??
  end

  def verify_token(user, token)
    user.token == token
  end

  def generate_token
    SecureRandom.hex
  end

  def preserve_token(user, token)
    if User.update(token: token)
      flash.notice = 'saved token'
    else
      flash.notice = 'token save failed'
    end
  end
end

