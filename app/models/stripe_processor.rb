module StripeProcessor
  def process_payment(order, user)
    Resque.enqueue(StripeJob, order.id, user.id, user.class.to_s)
  end
end
