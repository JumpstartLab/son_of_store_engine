class OrderMailer < ActionMailer::Base
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def order_confirmation_email(order)
    @order = order
    @email = order.find_shipping.email_address
    #@url  = order_path(@order.store, @order.id)
    @url = lookup_path(@order.store.to_param, @order.special_url)
    mail(to: @email, subject: "Thank you for your order!")
  end
end
