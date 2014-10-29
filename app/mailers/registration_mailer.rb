class RegistrationMailer < ActionMailer::Base
  default from: "no-reply@library.nyu.edu"

  def registration_email(user)
    @user_data = user
    emails = emails.collect {|email| email["email"]}
    mail(to: emails, subject: t('send_email.subject')) if emails.present?
  end

  private
  def emails
    (Figs.env['REGISTRATION_EMAILS'] || [])
  end
end
