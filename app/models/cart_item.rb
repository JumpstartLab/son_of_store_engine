class CartItem < ActiveRecord::Base
  attr_accessible :cart, :price, :product, :quantity
  belongs_to :cart
  belongs_to :product
end
# == Schema Information
#
# Table name: cart_items
#
#  id         :integer         not null, primary key
#  cart_id    :integer
#  product_id :integer
#  quantity   :integer
#  price      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#