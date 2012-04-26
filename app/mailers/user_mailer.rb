class UserMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    @url  = "http://daughterofstoreengine.herokuapp.com/"
    mail(:to => @user.email_address, :subject => "Welcome to DOSE!")
  end
end
