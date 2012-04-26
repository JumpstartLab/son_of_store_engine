class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def order_confirmation_email(order_id)
    @order = Order.find(order_id)
    @email = @order.find_shipping.email_address
    @url = "http://daughterofstoreengine.herokuapp.com/#{@order.store.to_param}/orders/lookup?sid=#{@order.special_url}"
    mail(to: @email, subject: "Thank you for your order!")
  end
end
