class OrderMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def order_confirmation(order)
    @order = order
    @user = order.user
    @products = order.order_products
    mail(to: @user.email, subject: "Order Confirmation")
  end
end
