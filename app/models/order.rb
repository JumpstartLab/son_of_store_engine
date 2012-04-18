class Order < ActiveRecord::Base
  attr_accessible :status, :customer, :customer_id

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
    cart.cart_items.each do |cart_item|
      cart_item.add_to_order(self)
    end
  end

  def self.create_from_cart(cart)
    o = Order.new(customer: Customer.find_or_create_by_user(cart.user))
    o.status = "paid"
    o.add_from_cart(cart)
    o.save!
    return o
  end

  def total
    order_items.each.inject(0) { |sum, item| sum + item.price*item.quantity}
  end

  def decimal_total
    Money.new(total)
  end

  def self.search(search_term, user)
    Order.where(:customer_id => user.customer.id).map do |order|
      order if order.matches?(search_term)
    end.compact
  end

  def cancelled?
    !cancelled.nil?
  end

  def matches?(search_term)
    products.each do |product|
      return true if product.matches?(search_term)
    end
  end
end
# == Schema Information
#
# Table name: orders
#
#  id          :integer         not null, primary key
#  status      :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  shipped     :date
#  cancelled   :date
#  customer_id :integer
#

