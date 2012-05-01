class Striper
  @queue = :stripe

  def self.perform(action, self_id, *object_ids)
    @card = CreditCard.find(credit_card_id)
    case action
    when "charge"
      charge(*object_ids)
    when "details"
      get_details(*object_ids)
    when "customer"
      create_customer(*object_ids)
    end

    def self.charge(cart_total_in_cents, stripe_customer_token)
      unless stripe_customer_token
        self.create_customer(credit_card_id, @card.stripe_card_token)
      end
      Stripe::Charge.create(amount: cart_total_in_cents,
        currency: 'usd',
        customer: stripe_customer_token)
    end

    def self.create_customer(token)
      @card.customer_stripe_token = Stripe::Customer.create(
        description: "Mittenberry Customer
        ##{card.user.id}", card: stripe_card_token)['id']
    end

    def self.set_details(stripe_card_token)
      create_customer(stripe_card_token)
      @card.credit_card = parse_stripe_customer_token(@card.stripe_customer_token)
    end

  end
end