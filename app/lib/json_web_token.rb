# lib/json_web_token.rb
class JsonWebToken # Note. Singleton class
  class << self
    def encode(payload, exp = 365.days.from_now) # One year token.
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
       nil
    end
  end
end

# Read more at https://www.pluralsight.com/guides/ruby-ruby-on-rails/
#  token-based-authentication-with-ruby-on-rails-5-api#xwOEV0GuBw6xfipm.99