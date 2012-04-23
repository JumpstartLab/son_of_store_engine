class ConfirmationMailer < ActionMailer::Base
  default from: "thanksforyourmoney@kaddox.com"

  def confirmation_email(user)
    @user = user
    mail(:to => user.email, :subject => "Your Kaddox.com Order Confirmation")
  end
end
