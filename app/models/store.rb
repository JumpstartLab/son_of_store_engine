class Store < ActiveRecord::Base
  attr_accessible :name, :path

  has_many :carts
  has_many :categories
  has_many :credit_cards
  has_many :orders
  has_many :products
  has_many :shipping_details

end
