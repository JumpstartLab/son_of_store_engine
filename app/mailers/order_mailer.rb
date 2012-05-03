class OrderMailer < ActionMailer::Base
  default from: "confirmation@sonofstoreengine.herokuapp.com"

  def order_confirmation(order)
    @order = order
    @user = order.user
    @url = "localhost:3000/orders/#{order.id.to_s}"
    @products = order.order_products
    mail(to: @user.email, subject: "Order Confirmation")
  end
end
