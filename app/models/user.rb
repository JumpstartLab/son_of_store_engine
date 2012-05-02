class User < ActiveRecord::Base
  authenticates_with_sorcery!

  PROMOTE = %w{ store_stocker store_admin }

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

  def get_cart_for_store(store)
    carts.where(:store_id => store.id).first || 
      carts.create!(:store_id => store.id)
  end

  def promote_to(role, store)
    if ( PROMOTE.include? role ) && ( roles.where(store_id: store.id).where(name: role).count == 0 )
      roles.create(name: role, store: store)
    else
      return false
    end
  end

  def has_role?(roles, store=nil)
    roles = Array(roles).map(&:to_s)

    if store
      store.roles.where("user_id = ? AND name in (?)", id, roles).count > 0
    else
      self.roles.where("user_id = ? AND name in (?)", id, roles).count > 0
    end
  end

  def find_cart_by_store_id(store_id)
    carts.where(:store_id => store_id).first
  end

  def notify_of_role_removal(name)
    if name == "store_admin" || name == "store_stocker"
      method_name = "#{name}_removal_notification"
    end 
    Resque.enqueue(RoleEmailer, method_name, id)
  end

  def notify_of_role_addition(name)
    if name == "store_admin" || name == "store_stocker"
      method_name = "#{name}_addition_notification"
    end
    Resque.enqueue(RoleEmailer, method_name, id)
  end
end
