class Cart < ActiveRecord::Base
  attr_accessible :cart_items, :user, :products
  has_many :cart_items
  has_many :products, :through => :cart_items
  has_one :user
  accepts_nested_attributes_for :cart_items

  def add_product(product)
    products << product
  end

  def add_product_by_id(product_id)
    product = Product.find_by_id(product_id)
    add_product(product)
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#