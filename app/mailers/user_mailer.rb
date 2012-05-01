class UserMailer < ActionMailer::Base
  default from: "info@berrystore.com"

  def user_confirmation(user)
    @user     = user
    mail(:to => @user.email, :subject => "You have been registered.",
      :body => "Congratulations! You have successfully been registered." )  
  end
end
