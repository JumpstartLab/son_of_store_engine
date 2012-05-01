class Striper
  @queue = :stripe

  def self.perform(action, self_id, *object_ids)
    @card = CreditCard.find(self_id)
    case action
    when "charge"
      charge(*object_ids)
    when "details"
      set_details(*object_ids)
    when "customer"
      create_customer(*object_ids)
    end
  end
  def self.charge(cart_total_in_cents, stripe_customer_token)
    unless stripe_customer_token
      self.create_customer(@card.id, @card.stripe_card_token)
    end
    Stripe::Charge.create(amount: cart_total_in_cents,
      currency: 'usd',
      customer: stripe_customer_token)
    @card.save
  end

  def self.create_customer(token)
    customer_token = Stripe::Customer.create(
      description: "Mittenberry Customer
      ##{@card.user.id}", card: token)
    @card.parse_stripe_customer_token(customer_token)
    @card.save
  end

  def self.set_details(stripe_card_token)
    create_customer(stripe_card_token)
    @card.save
  end

end