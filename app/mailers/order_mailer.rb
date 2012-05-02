# Responsible for all email related to orders and their creation or modification
class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "notifications@sonofstoreengine.com"

  def confirmation_email(order)
    @order = order
    mail(:to => order['email'], :subject => "Thank you for your order!")
  end
end
