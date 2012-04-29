class User < ActiveRecord::Base
  authenticates_with_sorcery!

  #CONSIDER TAKING CART_ID AWAY.
  attr_accessible :email, :name, :display_name, :password,
    :password_confirmation, :cart_id

  validates_presence_of :email
  validates_presence_of :name

  with_options :unless => :guest? do |user|
    user.validates_uniqueness_of :email
    user.validates_confirmation_of :password
    user.validates :password, length: { minimum: 6, maximum: 20 }
    user.validates :display_name, length: { minimum: 2, maximum: 32 },
      :unless => "display_name.blank?"
  end
  
  has_many :carts, :autosave => true
  has_many :credit_cards, :autosave => true
  has_many :orders
  has_many :shipping_details

  has_many :store_users
  has_many :stores, :through => :store_users

  ROLES = [ :store_stocker, :store_admin, :site_admin ]

  def role=(role)
    idx = ROLES.index(role)
    write_attribute(:role, idx)
  end

  def role
    idx = read_attribute(:role)
    ROLES[idx]
  end

  def add_order(order)
    orders << order
  end

  def recent_orders
    orders.limit(5)
  end

  def guest?
    type == "GuestUser"
  end

end
