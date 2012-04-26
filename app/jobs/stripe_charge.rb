class StripeCharge
  @queue = :stripe

  def self.perform(amount, user_id)
    user = User.find(user_id)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => user.stripe_id
    )
  end
end