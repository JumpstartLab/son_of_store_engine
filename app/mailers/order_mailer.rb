class OrderMailer < ActionMailer::Base
  default from: "info@berrystore.com",
          bcc: "darrell.rivera@livingsocial.com"

  def order_confirmation(order_id)
    @order = Order.find(order_id)
    @user = @order.user
    @products = @order.products
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "Thank you for your order")
  end
end
