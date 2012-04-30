class StripeCharge
  @queue = :stripe

  def self.perform(amount, stripe_id)
    BillingProcessor.charge(amount, stripe_id)
  end
end