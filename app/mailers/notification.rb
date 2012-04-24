# Sends out an email
class Notification < ActionMailer::Base
  default :from => "noreply@ehipster.herokuapp.com"

  def order_email(user, order)
    @user = user
    @order = order
    mail(:to => user.email, :subject => "Order Placed - ##{order.id}")
  end

  def sign_up_confirmation(user)
    @user = user
    mail(:to => user.email, :submect => "Welcome #{user.name}")
  end
end