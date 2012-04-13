class Customer < ActiveRecord::Base
  belongs_to :user

  attr_accessor :ship_address, :ship_address2, :ship_city, :ship_state,
  :ship_zipcode, :stripe_token

  def self.find_or_create_by_user(user)
    customer = Customer.find_by_user_id(user) || Customer.new
  end

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: user.email, card: stripe_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
