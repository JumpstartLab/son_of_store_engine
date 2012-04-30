class BillingProcessor
  def self.charge(amount, stripe_id)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => stripe_id
    )
  end
end
