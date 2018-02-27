# app/commands/authenticate_user.rb
class AuthenticateUser
  prepend SimpleCommand  # Adds alias's (list here) to class
  # TBD research this.

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    # has_secure_password provides authenticate method.
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid api credentials'
    nil
  end
end
