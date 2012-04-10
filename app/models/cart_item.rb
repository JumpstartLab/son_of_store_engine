class CartItem < ActiveRecord::Base
  attr_accessible :cart, :price, :product, :quantity, :cart_id
  belongs_to :cart
  belongs_to :product

  def add_to_order(order)
    order_item = OrderItem.new
    order_item.order_id = order.id
    order_item.product_id = self.product.id
    order_item.quantity = self.quantity
    order_item.price = self.product.price
    order_item.save
  end
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