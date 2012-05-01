class BillingProcessor
  def self.charge(amount, stripe_id)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => stripe_id
    )
  end
  def self.create_customer(user_id, token)
    user = User.find(user_id)
    customer = Stripe::Customer.create(
          :card => token,
          :description => user.email
        )
    user.stripe_id = customer.id
    user.save    
  end
end
