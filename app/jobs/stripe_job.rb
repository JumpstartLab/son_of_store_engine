class StripeJob
  @queue = :payments

  def self.perform(order_id, user_id, user_class)
    user = eval(user_class).find(user_id)
    order = Order.find(order_id)
    Stripe::Charge.create( :amount => order.total_price_in_cents.to_i, 
                          :currency => "usd", :customer => user.stripe_id, 
                          :description => "order##{order_id}" )
    order.paid
  end
end
