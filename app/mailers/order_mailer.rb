class OrderMailer < ActionMailer::Base
  default from: "thanksforyourmoney@daughterofstoreengine.com"

  def order_confirmation_email(order)
    @order = order
    @email = order.find_shipping.email_address
    #@url  = order_path(@order.store, @order.id)
    @url = link_to( :controller => "orders", :action => "lookup#show", :id => @order.id)
    mail(to: @email, subject: "Thank you for your order!")
  end
end
