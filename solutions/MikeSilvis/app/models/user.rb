# An authenticated person on the system
class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :display_name, :phone_number,
                  :guest
  attr_protected :permission

  default_scope :conditions => { :active => 1 }
  authenticates_with_sorcery!

  validates_uniqueness_of :email, :case_sensitive => false, :unless => :guest
  validates_presence_of :name, :email, :unless => :guest
  validates_presence_of :password, :on => :create, :unless => :guest
  validates_format_of :phone_number,
                      :with => /\A[0-9]{10}\Z/,
                      :allow_blank => true,
                      :allow_nil => true, :unless => :guest

  validates_length_of :display_name,
                      :within => 2..32,
                      :allow_blank => true,
                      :unless => :guest

  has_many :orders
  has_many :store_roles
  has_many :stores, :through => :store_roles
  has_many :products, :through => :orders
  has_many :product_ratings
  has_one :cart
  has_one :address
  after_create :send_confirmation_mail
  self.per_page = 15
  def guest_user
    self.guest == true
  end

  def send_confirmation_mail
    Resque.enqueue(NewUserEmailer, email)
  end

  def verify_user(input)
    add_email(input[:email]) if input[:email]
    Resque.enqueue(CheckAddress, self.id, input[:street], input[:zipcode])
  end

  def update_address(street, zipcode)
    addr = Address.new(
                        :street => street,
                        :zipcode => zipcode
                      )
    self.address = addr if addr.save
    self.save
  end

  def add_email(input)
    self.email = input
  end

  def admin?
    permission == 9
  end

  def user?
    permission == 1
  end

  def destroy
    self.active = 0
    self.save
  end

  def street
    if address
      address.street
    else
      ""
    end
  end
  def zipcode
    if address
      address.zipcode
    else
      ""
    end
  end

  def text(msg)
    send_text(msg, self.phone_number) if not self.phone_number.blank?
  end

  def billing_address
    addresses.billing
  end

  def shipping_address
    addresses.shipping
  end

end
