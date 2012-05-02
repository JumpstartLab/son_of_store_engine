# class to deliver emails pertaining to users
class UserMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "darrell.rivera@livingsocial.com"

  def user_confirmation(email)
    mail(:to => email, :subject => "You have been registered.",
      :body => "Congratulations! You have successfully been registered." )  
  end

  def signup_notification(email)
    mail(:to => email, :subject => "Please signup with StoreBerry")
  end
end
