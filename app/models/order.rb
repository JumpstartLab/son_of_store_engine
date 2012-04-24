# == Schema Information
#
# Table name: orders
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  status     :string(255)
#  address_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

# An order is created when a user checks out with products
class Order < ActiveRecord::Base
  attr_accessible :user_id, :status, :order_items_attributes, :address_id

  has_many :order_items
  has_many :products, :through => :order_items
  belongs_to :address
  has_one :cart
  belongs_to :user

  accepts_nested_attributes_for :order_items

  def self.collect_by_status
    orders_by_status = {}
    Order.statuses.each do |status|
      orders_by_status[status] = Order.find_all_by_status(status)
    end
    orders_by_status
  end

  def self.statuses
    Order.all.map(&:status).uniq
  end

  def self.create_from_cart(cart)
    order = Order.create(:status => "pending")
    cart.products.each { |product| order.add_product(product) }
    order.save
    order
  end

  def add_product(product)
    if products.include?(product)
      increment_quantity_for(product)
    else
      products << product
    end
  end

  def increment_quantity_for(product)
    oi = OrderItem.find_by_product_id(product.id)
    oi.update_attribute(:quantity, oi.quantity + 1)
  end

  def total
    @total ||= products.inject(0) { |sum, product| sum + subtotal(product) }
  end

  def subtotal(product)
    oi = OrderItem.find_by_product_id(product.id)
    (oi.quantity * oi.product.price).round(2)
  end

  def quantity_for(product)
    oi = OrderItem.find_by_product_id(product.id)
    oi.quantity
  end

  def items
    order_items
  end

  def set_status(status)
    self.status = status
    save
  end
end
