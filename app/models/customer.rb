class Customer < ActiveRecord::Base
  belongs_to :user

  attr_accessible :ship_address, :ship_address2, :ship_city, :ship_state,
  :ship_zipcode, :stripe_customer_token, :user_id

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
# == Schema Information
#
# Table name: customers
#
#  id                    :integer         not null, primary key
#  stripe_token          :string(255)
#  user_id               :integer
#  ship_address          :string(255)
#  ship_address2         :string(255)
#  ship_state            :string(255)
#  ship_zipcode          :string(255)
#  ship_city             :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  stripe_customer_token :string(255)
#

