class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create]

  # def new # Not Used. Form up directly
  #   @user = User.new
  # end

  def create # This is user registration
    is_user_already_logged_in
    if ! is_user_already_registered
      new_user = create_new_user
      establish_session(new_user)
      flash.notice = "created"
    end
    # Hits views/users/create.js.erb
  end

  def update
    # How to change password, phone number, or two_fa_enabled. Future.
    @user = User.find(params[:id])
    process_update
  end

  # def edit # Not Used. Form up directly.
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
      flash.notice = 'User logged in, logout first'
      # redirect_to root_url and return
    end
  end

  def is_user_already_registered
    if User.find_by(email: params[:email])
      flash.notice = "User already registered, just login"
      true
    else
      false
    end
  end

  def create_new_user
    flash.notice = user_params[:email]
    new_user = User.create(user_params)
    if ! new_user
      flash.notice = "Failed to create user"
    end
    new_user
  end
end