class RegistrationMailer < ActionMailer::Base
  default from: "lib-no-reply@nyu.edu"

  def registration_email(user)
    @user_data = user
    emails = registration_emails.collect { |email| email["email"] }
    mail(to: emails, cc: @user_data.email, subject: t('send_email.subject')) if emails.present?
  end

  private
  def registration_emails
    (ENV['REGISTRATION_EMAILS']&.split('::')&.map {|e| e.split(':').last } || [])
  end
end
