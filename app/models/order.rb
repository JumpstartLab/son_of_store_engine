class Order < ActiveRecord::Base
  attr_accessible :status, :customer
  belongs_to :customer
  has_one :user, :through => :customer
  has_many :order_items
  has_many :products, :through => :order_items
  accepts_nested_attributes_for :customer

  def update_attributes(params)
    self.shipped = Time.now if params[:status] == "shipped" && status != "shipped"
    self.cancelled = Time.now if params[:status] == "cancelled" && status != "cancelled"
    super
  end

  def add_from_cart(cart)
    self.status = "pending"
    cart.cart_items.each do |cart_item|
      cart_item.add_to_order(self)
    end
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

