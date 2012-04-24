class Store < ActiveRecord::Base
  has_many :products
  has_many :orders
  has_many :categories

  attr_accessible :name, :domain
end
