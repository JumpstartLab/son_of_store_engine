class Cart < ActiveRecord::Base
  attr_accessible :cart_items, :user_id, :products, :user, :cart_id
  has_many :cart_items
  has_many :products, :through => :cart_items
  has_one :user
  accepts_nested_attributes_for :cart_items

  def add_product(product)
    unless products.include? product
      products << product
    else
      selected = cart_items.select do |cart_item|
        cart_item.product == product
      end
      selected.first.tap{|c| c.quantity += 1}.save
    end
  end

  def add_product_by_id(product_id)
    product = Product.find_by_id(product_id)
    add_product(product)
  end

  def empty?
    self.cart_items.size == 0
  end

  def clear
    self.cart_items.each do |cart_item|
      cart_item.destroy
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