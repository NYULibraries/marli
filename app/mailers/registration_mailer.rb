class RegistrationMailer < ActionMailer::Base
  default from: "no-reply@library.nyu.edu"
  
  def registration_email(user)
    @user_data = user
    emails = Settings.emails.collect {|email| email["email"]}
    mail(:to => emails, :subject => t('send_email.subject'))
  end
end
