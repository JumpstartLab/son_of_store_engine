class BillingProcessor
  def self.charge(amount, user)
    Resque.enqueue(StripeCharge, amount, user.stripe_id)
  end
end
