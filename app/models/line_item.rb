#
class LineItem < ActiveRecord::Base
  attr_accessible :order_id, :price, :product_id, :quantity
  belongs_to :product
  belongs_to :order

  def self.increment_or_create_line_item(params)
    order = Order.find(params[:order_id])

    params[:price] = params[:price].to_f*100

    if order.has_product?(params[:product_id])
      line_item = order.line_items.find_by_product_id(params[:product_id])
      line_item.increment_quantity(params[:quantity])
    else
      line_item = LineItem.create(params)
    end
  end

  def subtotal
    BigDecimal.new((quantity.to_f * price.to_f).to_s, 2)
  end

  def price
    cents = BigDecimal.new(read_attribute(:price).to_s)
    price = cents / 100
  end

  def clean_price
    BigDecimal.new(price.to_f, 2)
  end

  def increment_quantity(amount)
    self.quantity += amount.to_i
    self.save
    self.quantity
  end

  def title
    product.title
  end
end
# == Schema Information
#
# Table name: line_items
#
#  id         :integer         not null, primary key
#  order_id   :integer
#  product_id :integer
#  quantity   :integer
#  price      :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

