require 'digest/sha1'

class Order < ActiveRecord::Base
  
  VALID_STATUSES = ['pending', 'paid', 'shipped', 'cancelled', 'returned']
  attr_accessible :status, :total_price, :user,
                  :products, :address_attributes,
                  :address, :address_id, :status
  attr_accessor :stripe_card_token
  attr_accessible :stripe_card_token

  has_many :order_items
  has_many :products, through: :order_items
  belongs_to :store
  belongs_to :user
  belongs_to :visitor_user
  belongs_to :address

  validates_presence_of :store_id

  scope :pending, where(status: "pending")
  scope :paid, where(status: "paid")
  scope :shipped, where(status: "shipped")
  scope :cancelled, where(status: "cancelled")
  scope :returned, where(status: "returned")

  after_create :set_default_status
  after_create :generate_unique_url
  after_create :send_confirmation_email
  after_create :expire_top_seller_cache

  def expire_top_seller_cache
    Rails.cache.write("#{store.slug}_top_seller", nil)
  end

  def set_default_status
    update_attribute(:status, "pending")
  end

  accepts_nested_attributes_for :address

  def self.revenue(store = nil)
    if store
      @orders = store.orders
    else
      @orders = Order.all
    end
    @orders.inject(0) do |result, order|
      result += order.total_price
    end
  end

  def total_price
    order_items.inject(0) do |result, item|
      result += item.unit_price * item.quantity
    end
  end

  def total_price_in_cents
    total_price * 100
  end

  def email
    (user || visitor_user).email
  end

  def save_with_payment
    if valid?
      create_stripe_user(stripe_card_token) unless order_user.stripe_id
      Stripe::Charge.create(
        :amount => total_price_in_cents.to_i,
        :currency => "usd",
        :customer => order_user.stripe_id,
        :description => "order##{id}" )
      is_paid!
      save!
    end
    rescue Stripe::InvalidRequestError => error
    logger.error "Stripe error while creating customer: #{error.message}"
    errors.add :base, "There was a problem with your credit card."
  end

  def create_stripe_user(token)
    customer = Stripe::Customer.create(description: order_user.email,
      card: token)
    order_user.update_attribute(:stripe_id, customer.id)
  end

  def add_order_items_from(cart)
    cart.cart_items.each do |item|
      oi = OrderItem.new( quantity: item.quantity,
                unit_price: item.individual_price,
                order_id: self.id)
      oi.product = item.product
      oi.save
    end
  end

  def current_status
    status
  end

  def is_paid!
    update_attribute(:status, "paid")
  end

  def update_status(new_status)
    if VALID_STATUSES.include?(new_status)
      update_attribute(:status, new_status)
      BackgroundJob.order_status_email(order_user, self)
    end
  end

  def two_click(product_id)
    product = Product.find(product_id)
    OrderItem.create( quantity: 1,
      unit_price: product.price,
      order_id: self.id,
      product_id: product.id)
    update_attribute(:address, user.addresses.first)
  end


  private

  def order_user
   if user
      User.find_by_id(user.id) 
    else 
      VisitorUser.find_by_id(visitor_user.id)
    end
  end

  def generate_unique_url
    self.unique_url = Digest::SHA1.hexdigest("store-order-url-#{id}")
    save
  end

  def send_confirmation_email
    BackgroundJob.order_email(order_user, self)
  end
end
