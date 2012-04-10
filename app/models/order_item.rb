class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :order, :product, :price, :product_id, :quantity
  belongs_to :order
  belongs_to :product

  def decimal_price
    Money.new(price)
  end

  def total
    price*quantity
  end

  def decimal_total
    Money.new(total)
  end
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

