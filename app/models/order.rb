class Order < ActiveRecord::Base
  attr_accessible :status, :user_id
  belongs_to :customer
  belongs_to :user
  has_many :order_items
  has_many :products, :through => :order_items
  accepts_nested_attributes_for :customer

  def update_attributes(params)
    self.shipped = Time.now if params[:status] == "shipped" && status != "shipped"
    self.cancelled = Time.now if params[:status] == "cancelled" && status != "cancelled"
    super
  end

  def self.create_from_cart(cart)
    order = Order.create
    order.user_id = cart.user_id
    order.status = "pending"
    cart.cart_items.each do |cart_item|
      cart_item.add_to_order(order)
    end
    order.save
    order
  end

  def total
    order_items.each.inject(0) { |sum, item| sum + item.price*item.quantity}
  end

  def decimal_total
    Money.new(total)
  end
end
# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  shipped    :date
#  cancelled  :date
#

