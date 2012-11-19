# Notifies users of significant events regarding their accounts.
class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default :from => "notifications@sonofstoreengine.com"

  def welcome_email(user)
    @user = user
    @url  = "http://sonofstoreengine.com/login"
    mail(:to => user["email"], :subject => "Welcome to sonofstoreengine.com!")
  end
end
