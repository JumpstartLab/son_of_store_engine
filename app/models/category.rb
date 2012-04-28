class Category < ActiveRecord::Base
  attr_accessible :name, :store_id

  has_one :discount

  has_many :product_categories
  has_many :products, :through => :product_categories
  belongs_to :store

  validates_uniqueness_of :name
  validates_presence_of :name
end
