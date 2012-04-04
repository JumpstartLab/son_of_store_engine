class CartItem < ActiveRecord::Base
  attr_accessible :cart_id, :price, :product_id, :quantity
end
