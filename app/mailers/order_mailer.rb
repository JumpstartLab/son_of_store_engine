class OrderMailer < ActionMailer::Base
  default from: "hungry.store.engine@gmail.com"

  def order_confirmation_email(order)
    @order = order
    @email = order.find_shipping.email_address
    #@url  = order_path(@order.store, @order.id)
    @url = "/#{@order.store.to_param}/orders/#{@order.special_url}"
    mail(to: @email, subject: "Thank you for your order!")
  end
end
