# == Schema Information
#
# Table name: categories
#
#  id                  :integer         not null, primary key
#  product_category_id :integer
#  name                :string(255)
#  store_id            :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

# A collection of similar products
class Category < ActiveRecord::Base
  attr_accessible :name, :product_category_id
  has_many :product_categories
  has_many :products, :through => :product_categories
  belongs_to :store

  def add_product(product)
    products << product
  end
end
