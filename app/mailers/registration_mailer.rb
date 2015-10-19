class RegistrationMailer < ActionMailer::Base
  default from: "lib-no-reply@nyu.edu"

  def registration_email(user)
    @user_data = user
    emails = registration_emails.collect { |email| email["email"] }
    mail(to: emails, cc: @user_data.email, subject: t('send_email.subject')) if emails.present?
  end

  private
  def registration_emails
    (Figs.env['REGISTRATION_EMAILS'] || [])
  end
end
