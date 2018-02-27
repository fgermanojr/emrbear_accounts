module MyHelpers
  require 'mailit'

  def send_mail_delayed(from, to, subject, msg)
    Delayed::Job.enqueue Mailit::MailerJob.new(from, to, subject, msg)
  end

end