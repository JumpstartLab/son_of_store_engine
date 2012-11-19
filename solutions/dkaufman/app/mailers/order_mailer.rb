class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def order_confirmation_email(order_id)
    @order = Order.find(order_id)
    @email = @order.find_shipping.email_address
    set_url
    mail(to: @email, subject: "Thank you for your order!")
  end

  def set_url
    root = "http://daughterofstoreengine.herokuapp.com/"
    sid = "?sid=#{@order.special_url}"
    @url = "#{root}#{@order.store.to_param}/orders/lookup/#{sid}"
    # @url = orders_path(@order.store, sid: @order.special_url)
  end
end
