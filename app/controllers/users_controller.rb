class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create]

  def new
    flash.notice = 'USER CREATE'
    render_in_modal('/users/new')
  end


  def create # This is user registration
    is_user_already_logged_in
    if ! is_user_already_registered
      new_user = create_new_user
      establish_session(new_user, false)
    end
    # Hits views/users/create.js.erb
  end

  def update   # TBD ? Should I use this for 2fa on create?  CHECK SPEC
    # # How to change password, phone number, or two_fa_enabled. Future.
    # @user = User.find(params[:id])
    # process_update
  end

  # Form up directly. That would be so w 2fa on create edit/update
  # def edit # Not Used.
  #   @user = User.find(params[:id])
  # end

  def destroy
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def is_user_already_logged_in
    if session[:user_id]
      flash.notice = 'Current user logged out'
      session[:user_id] = nil
      @current_user = nil
    end
  end

  def is_user_already_registered
    if User.find_by(email: params[:email])
      flash.notice = 'User already registered, just login'
      true
    else
      false
    end
  end

  def create_new_user
    flash.notice = user_params[:email]
    new_user = User.create(user_params)
    if new_user
      flash.notice = 'User created'
    else
      flash.notice = 'Failed to create user'
    end
    new_user
  end
end
