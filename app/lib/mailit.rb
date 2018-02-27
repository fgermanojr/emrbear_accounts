module Mailit
  require 'mailgun-ruby'

  class MailerJob < Struct.new(:from, :email_tos, :title, :msg)
    def perform
      @mailer ||= Mailit::MyMailer.new
      email_tos.each { |e| @mailer.send_mailgun(from, e, title, msg) }
    end
  end

  class MyMailer
    def initialize
      # instantiate the Mailgun Client with your API key (private)
      @mailgun = Mailgun::Client.new 'key-9d0a675cdd6bc30812052cefd05c1195'
    end

    def send_mailgun(from, to, subject, text)
      message_params =  { to: to, from: from, subject: subject, text: text }
      result = @mailgun.send_message('mail.germano.org', message_params).to_h
      message_id = result['id']
      message = result['message']
      puts '-----'
      puts result.inspect
      puts '====='
    end
  end
end

# NOTE. to start worker manually in development use
# docker-compose exec web rake jobs:work
