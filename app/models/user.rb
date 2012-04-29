class User < ActiveRecord::Base
  has_secure_password
  has_one :cart
  has_many :addresses
  has_many :orders
  has_many :privileges

  attr_accessible :full_name, :email, :display_name,
                  :username, :password,
                  :password_confirmation

  validates_presence_of :full_name, :password, :password_confirmation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates_length_of :username,
                      :minimum => 2,
                      :maximum => 32,
                      :allow_blank => true

                      
  def stores
    Store.where(owner_id: id)
  end

  def promote(store, role)
    privileges.create(store_id: store.id, name: role)
  end

  def store_privileges(store)
    privileges.where(store_id: store.id)
  end

  def may_manage?(store)
    return true if admin
    (store.owner == self) || store_privileges(store).map(&:name).include?("manager")
  end

  def may_stock?(store)
    may_manage?(store) || store_privileges(store).map(&:name).include?("stocker")
  end
end
