class Cart < ActiveRecord::Base
  attr_accessible :cart_items, :user_id, :products, :user, :cart_id
  has_many :cart_items
  has_many :products, :through => :cart_items
  has_one :user
  accepts_nested_attributes_for :cart_items

  def add_product(product)
    products << product
  end

  def add_product_by_id(product_id)
    product = Product.find_by_id(product_id)
    add_product(product)
  end

  def count
    @count ||= update_count
  end

  def empty?
    self.count == 0
  end

  def clear
    self.cart_items.each do |cart_item|
      cart_item.destroy
    end
  end

  def update_count
    @count = cart_items.inject(0) do |sum, cart_item|
      sum += cart_item.quantity
    end
  end

  def absorb(other_cart)
    if other_cart
      other_cart.cart_items.each do |cart_item|
        cart_item.cart_id = self.id
        cart_item.save
      end
    end
  end
end
# == Schema Information
#
# Table name: carts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#