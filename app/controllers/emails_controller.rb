class EmailsController < ApplicationController
  include MyHelpers

  def new
    # puts up send email modal
  end

  def send_email  # "create"
    result = prepare_email
    if result
      from, to, subject, msg = prepare_email
      send_mail_delayed(from, to, subject, msg) # In app/lib/my_helpers.rb
      flash.notice = 'sent email'
    else
      flash.notice = 'to, subject, or message is missing'
    end
    # hits send_email.js.erb, which removes the modal
  end

  private

  def emails_params
    params.require(:emails).permit(:to, :subject, :msg)
  end

  def prepare_email
    if emails_params[:to].nil? ||
           emails_params[:subject].nil? ||
           emails_params[:msg].nil?
      result = nil
    else
      from = session[:email]
      to = fix_up_to(emails_params[:to])
      subject = emails_params[:subject]
      msg = emails_params[:msg]
      result = [from, to, subject, msg]
    end
    result
  end

  def fix_up_to(to)
    to.include?(',') ? to.split(',') : [to]
  end
end