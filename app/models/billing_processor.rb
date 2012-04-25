class BillingProcessor
  def self.charge(amount, user)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => user.stripe_id
    )
  end
end