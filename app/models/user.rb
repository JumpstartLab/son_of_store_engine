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
  has_many :carts, :autosave => true
  has_many :store_users
  has_many :stores, :through => :store_users

  def add_order(order)
    orders << order
  end

  def recent_orders
    orders.limit(5)
  end

  # def cart=(new_cart)
  #   cart.destroy if cart #if user has cart, destroy
  #   write_attribute(:cart, new_cart)
  # end

end
