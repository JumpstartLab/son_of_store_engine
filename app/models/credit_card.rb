class CreditCard < ActiveRecord::Base
  attr_accessible :credit_card_type, :last_four, :exp_month, :exp_year,
    :stripe_customer_token, :user_id, :default_card
  attr_accessor :stripe_card_token
  validates_presence_of :user_id
  before_save :set_to_default
  belongs_to :user
  after_create :add_details_from_stripe_card_token

  def set_to_default
    user = User.find(self.user_id)
    self.default_card = true unless user.credit_cards.find_by_default_card(true)
  end

  def add_details_from_stripe_card_token
    Resque.enqueue(Striper, "details", self.id, self.stripe_card_token)
  end

  def stripe_get_customer_token(stripe_card_token)
    Resque.enqueue(Striper, "customer", self.id, stripe_card_token)
  rescue Stripe::InvalidRequestError => error
    send_customer_create_error(error)
  end

  def formatted_last_four
    "XXXX-XXXX-XXXX-#{last_four}"
  end

  def formatted_exp_date
    "#{exp_month}/#{exp_year}"
  end

  def charge_as_guest(cart_total_in_cents)
    Resque.enqueue(Striper,"charge", self.id, cart_total_in_cents, stripe_card_token)
  rescue Stripe::InvalidRequestError => error
    send_charge_error(error)
  end

  def charge(cart_total_in_cents)
    Resque.enqueue(Striper,"charge", self.id, cart_total_in_cents, stripe_customer_token)
  rescue Stripe::InvalidRequestError => error
    send_charge_error(error)
  end

  def parse_stripe_customer_token(customer_token)
    save_card_details(customer_token["active_card"])
    save
  end
private
  def send_charge_error(e)
    logger.error "Stripe error while charging customer: #{e.message}"
    errors.add :base, "There was a problem with the charge."
    false
  end

  def send_customer_create_error(e)
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def save_card_details(card_details)
    self.last_four = card_details["last4"]
    self.credit_card_type = card_details["type"]
    self.exp_month = card_details["exp_month"]
    self.exp_year = card_details["exp_year"]
    save
  end
end
