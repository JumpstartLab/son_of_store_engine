# model for orders
class Order < ActiveRecord::Base
  attr_accessible :user_id, :credit_card_id, :order_products

  belongs_to :credit_card, :autosave => true
  belongs_to :shipping_detail, :autosave => true
  belongs_to :store
  belongs_to :user

  has_many :order_products, :dependent => :destroy
  has_many :products, :through => :order_products
  has_one :order_status, :dependent => :destroy

  validates_presence_of :user_id
  validates_presence_of :order_products

  before_create :make_new_order_status

  scope :desc, order("id DESC")

  def self.orders_by_status(status_filter=nil)
    if status_filter.nil?
      Order.all
    else
      Order.joins(:order_status).
        where('order_statuses.status = ?', status_filter)
    end
  end

  def self.user_by_order_id(id)
    order = Order.find_by_id(id)
    order.user if order
  end

  def self.build_for_user(user, cart)
    order = user.orders.build
    order.build_order_from_cart(cart)
    order
  end

  def self.build_for_guest_user(user, cart, params)
    order = user.orders.build
    order.build_order_from_cart(cart)
    order.shipping_detail = user.shipping_details.build(params[:shipping_detail])
    order.credit_card = user.credit_cards.build(last_four: params[:number],
                                                exp_month: params[:month],
                                                exp_year: params[:year])
    # order.credit_card = user.credit_cards.build_from_stripe_for(user, params[:credit_card])
    order
  end

  def add_shipping_detail_for(user, attributes)
    self.shipping_detail = user.shipping_details.find(
      attributes[:shipping_detail_id])
  end

  def make_new_order_status
    self.build_order_status
  end

  def status
    result = self.order_status.status
    result ? result : ""
  end

  def store_name
    store.name
  end

  def mark_as_paid
    self.order_status.update_attributes(:status => 'paid')
  end

  def build_order_from_cart(cart)
    if cart.has_products?
      cart.cart_products.each do |cart_prod|
        self.order_products.build(:price_cents => cart_prod.price_in_cents,
                                  :product_id => cart_prod.product_id,
                                  :quantity => cart_prod.quantity)
      end
    end
  end

  def charge(cart)
    if credit_card.charge(cart.cart_total_in_cents)
      mark_as_paid
      cart.destroy
      true
    else
      false
    end
  end

  def set_cc_from_stripe_customer_token(token)
    if credit_card = user.credit_cards.find_by_stripe_customer_token(token)
      self.credit_card = credit_card
    end
  end

  def order_total
    order_products.inject(Money.new(0, "USD")) do |total, order_product|
      total + order_product.price * order_product.quantity
    end
  end

  def send_order_confirmation
    Resque.enqueue(OrderEmailer, "order_confirmation", id)
  end

end
