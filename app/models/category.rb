# model for categories
class Category < ActiveRecord::Base
  attr_accessible :name

  has_one :discount
  belongs_to :store

  has_many :product_categories
  has_many :products, :through => :product_categories

  validates_uniqueness_of :name, :scope => :store_id
  validates_presence_of :name

  def active_products
    products.where(retired: false)
  end

end
