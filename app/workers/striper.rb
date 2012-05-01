class Striper
  @queue = :stripe

  def self.perform(action, self_id, *object_ids)
    case action
    when "charge"
      charge(self_id, *object_ids)
    when "token"
    when "customer"
      create_customer(self_id, *object_ids)
    end

    def self.charge(credit_card_id, cart_total_in_cents, stripe_customer_token)
      card = CreditCard.find(credit_card_id)
      unless stripe_customer_token
        self.create_customer(credit_card_id, card.stripe_card_token)
      end
      Stripe::Charge.create(amount: cart_total_in_cents,
        currency: 'usd',
        customer: stripe_customer_token)
    end

    def self.create_customer(credit_card_id, token)
      card = CreditCard.find(credit_card_id)
      Stripe::Customer.create( description: "Mittenberry Customer
        ##{card.user.id}", card: stripe_card_token)
    end

  end