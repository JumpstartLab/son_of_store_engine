class User < ActiveRecord::Base
  authenticates_with_sorcery!

  #CONSIDER TAKING CART_ID AWAY.
  attr_accessible :email, :name, :display_name, :password,
    :password_confirmation, :cart_id

  validates_confirmation_of :password
  validates :password, length: { minimum: 6, maximum: 20 }
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :name
  validates :display_name, length: { minimum: 2, maximum: 32 },
    :unless => "display_name.blank?"

  has_many :orders
  has_many :credit_cards
  has_many :shipping_details
  has_one :cart

  def add_order(order)
    self.orders << order
  end

  def recent_orders
    self.orders.limit(5)
  end
end
