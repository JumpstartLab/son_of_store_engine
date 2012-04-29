class User < ActiveRecord::Base
  authenticates_with_sorcery!

  #CONSIDER TAKING CART_ID AWAY.
  attr_accessible :email, :name, :display_name, :password,
    :password_confirmation, :cart_id, :guest
  validates_confirmation_of :password, unless: "guest"
  validates :password, length: { minimum: 6, maximum: 20 }, unless: "guest"
  validates_presence_of :email
  validates_uniqueness_of :email, unless: "guest"
  validates_presence_of :name, unless: "guest"
  validates :display_name, length: { minimum: 2, maximum: 32 },
    :unless => "display_name.blank? || guest"
  has_many :orders
  has_many :credit_cards
  has_many :shipping_details
  has_one :cart
  has_many :store_admins
  has_many :stores, :through => :store_admins

  after_create :confirm_signup

  def add_order(order)
    self.orders << order
  end

  def confirm_signup
    Resque.enqueue(Emailer, "user", "signup", self.id)
  end

  def recent_orders
    self.orders.limit(5)
  end
end
