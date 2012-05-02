class UserMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "travis.valentine@livingsocial.com"

  def user_confirmation(user)
    @user     = user
    mail(:to => @user.email, :subject => "You have been registered.",
      :body => "Congratulations! You have successfully been registered." )  
  end

  def signup_notification(email)
    mail(:to => email, :subject => "Please signup with StoreBerry")
  end
end
