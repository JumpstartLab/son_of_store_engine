class Store < ActiveRecord::Base
  attr_accessible :name, :slug, :owner_id

  has_many :products
  has_many :privileges
  has_many :carts
  has_many :orders

  validates_presence_of :owner_id

end
