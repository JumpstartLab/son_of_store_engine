class BillingProcessor
  def self.charge(amount, user)
    Resque.enqueue(StripeCharge, amount, user.id)
  end
end
