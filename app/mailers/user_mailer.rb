class UserMailer < ActionMailer::Base
  default from: "storeengine2@gmail.com"

  def signup_confirmation(user)
    @user = user
    mail(to: @user.email, subject:"Welcome to Store Engine!")
  end
end
