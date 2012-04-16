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

  def self.search(search_term, user)
    matching_orders = []
    if find_by_id(user.customer.id)
      find_by_id(user.customer.id).each do |order|
        if order.matches(search_term)
          matching_orders << order
        end
      end
    end
  end

  def matches(search_term)
    products.each do |product|
      if product.matches(search_term)
        return true
      end
    end
    return false
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

