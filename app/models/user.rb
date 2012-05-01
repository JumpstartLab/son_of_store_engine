class User < ActiveRecord::Base
  authenticates_with_sorcery!

  #CONSIDER TAKING CART_ID AWAY.
  attr_accessible :email, :name, :display_name, :password,
    :password_confirmation, :cart_id

  validates_presence_of :email
  validates_presence_of :name

  with_options :unless => :guest? do |user|
    user.validates :email, :uniqueness => true
    user.validates_confirmation_of :password
    user.validates :password, length: { minimum: 6, maximum: 20 }
    user.validates :display_name, length: { minimum: 2, maximum: 32 },
      :unless => "display_name.blank?"
  end
  
  has_many :carts, :autosave => true
  has_many :credit_cards, :autosave => true
  has_many :orders
  has_many :shipping_details

  # has_many :store_users
  # has_many :stores, :through => :store_users

  has_many :roles
  has_many :stores, :through => :roles

  # def email=(email)
  #   @email = email.downcase
  # end

  def add_order(order)
    orders << order
  end

  def recent_orders
    orders.limit(5)
  end

  def guest?
    type == "GuestUser"
  end

  def has_role?(role, store=nil)
    role = role.to_s
    if store
      store.roles.where(user_id: id, name: role).count > 0
    else
      roles.where(name: role).count > 0
    end
  end

  def find_cart_by_store_id(store_id)
    carts.where(:store_id => store_id).first
  end

end
