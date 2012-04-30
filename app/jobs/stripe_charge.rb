class StripeCharge
  @queue = :stripe

  def self.perform(amount, stripe_id)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => stripe_id
    )
  end
end