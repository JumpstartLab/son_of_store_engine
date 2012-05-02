class OrderMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "travis.valentine@livingsocial.com"

  def order_confirmation(user_id)
    @user = User.find(user_id)
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "Thank you for your order")
  end
end
