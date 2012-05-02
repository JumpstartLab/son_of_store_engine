# model for carts
class Cart < ActiveRecord::Base
  extend StoreQueries

  attr_accessible :store, :store_id

  has_many :cart_products, :dependent => :destroy, :autosave => true
  has_many :products, :through => :cart_products
  belongs_to :user
  belongs_to :store

  def add_product_by_id(id)
    product = store.products.where(:id => id).first
    add_product(product) if product && product.active?
  end

  def remove_product_by_id(id)
    product = store.products.find(id)
    remove_product(product)
  end

  def product_if_product_id_exists(id)
    self.cart_products.find_by_product_id(id)
  end

  def add_product(product)
    if existing_product = product_if_product_id_exists(product.id)
      existing_product.quantity += 1
      existing_product.save
    else
      cart_products.create(:cart => self, :product => product,
                           :quantity => 1 )
    end
  end

  def remove_product(product)
    self.products.delete(product)
  end

  def cart_count
    cart_products.map(&:quantity).inject(:+) || 0
  end

  def has_products?
    cart_products.any?
  end

  def is_empty?
    cart_products.empty?
  end

  def cart_total
    cart_products.inject(Money.new(0, "USD")) do |total, cart_product|
      total + cart_product.price * cart_product.quantity
    end
  end

  def cart_total_in_cents
    cart_products.inject(0) do |total, cart_product|
      total + cart_product.price_in_cents * cart_product.quantity
    end
  end

end
