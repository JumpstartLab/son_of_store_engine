class Cart < ActiveRecord::Base
  attr_accessor :total, :user_id

  has_many :cart_products, :dependent => :destroy
  has_many :products, :through => :cart_products
  belongs_to :user
  validates_uniqueness_of :user_id, :allow_nil => true

  def add_product_by_id(id)
    product = Product.find(id)
    if product.active?
      add_product(product)
    else
      return false
    end
  end

  def remove_product_by_id(id)
    product = Product.find(id)
    remove_product(product)
  end

  def empty?
    not   cart_products.any?
  end

  def product_if_product_id_exists(id)
    self.cart_products.find_by_product_id(id)
  end

  def add_product(product)
    if existing_product = product_if_product_id_exists(product.id)
      existing_product.quantity += 1
      existing_product.save
    else
      self.cart_products.create(:cart_id => self.id, :product_id => product.id,
                                :quantity => 1 )
    end
  end

  def assign_cart_to_user(user)
    if has_products?
      user.cart.destroy if user.cart #if user has cart, destroy
      user.cart = self
    else
      destroy #if cart has no products, destroy
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
