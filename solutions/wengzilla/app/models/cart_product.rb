# model for cart_products
class CartProduct < ActiveRecord::Base
  attr_accessible :cart, :product, :quantity

  validates_numericality_of :quantity, :greater_than_or_equal_to => 0

  belongs_to :cart
  belongs_to :product

  def name
    product.name
  end

  def subtotal
    product.price * self.quantity
  end

  def price
    product.price #Adjust for sale price.
  end

  def price_in_cents
    product.price_cents #Adjust for sale price.
  end

  def update_quantity(quantity)
    if quantity.to_i <= 0
      destroy
    else
      update_attribute(:quantity, quantity)
    end
  end

end
