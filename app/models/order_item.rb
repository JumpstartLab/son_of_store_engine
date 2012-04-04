class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :price, :product_id, :quantity
end
# == Schema Information
#
# Table name: order_items
#
#  id         :integer         not null, primary key
#  order_id   :integer
#  product_id :integer
#  quantity   :integer
#  price      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

