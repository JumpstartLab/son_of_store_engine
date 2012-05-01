class OrdersController < ApplicationController

  before_filter :require_login, except: [:show]

  def new
    if current_user.credit_cards.empty?
      redirect_to new_credit_card_path and return
    end

    if current_user.shipping_details.empty?
      redirect_to new_shipping_detail_path and return
    end
    @credit_card = current_user.credit_cards.last
    @shipping_detail = current_user.shipping_details.last
    @order = Order.new
  end

  def index
    @orders = current_user.orders.desc
  end

  def create
    @or = current_user.orders.create
    build_order_from_cart(params)

    if @or.set_cc_from_stripe_customer_token(params[:order][:customer_token])
      @or.send_confirmation
      redirect_to @or,
        :notice => "Thank you for placing an order." if @or.charge(current_cart)
      # TODO: Fix where the redirect happens here! It's not hitting render :new right... we need a fail option?
    else
      render :new
    end
  end

  def show
    @order = OrdersController.find_by_id_or_sha1(params[:id])
    @shipping_detail = @order.shipping_detail
    redirect_to root_path, :notice => "Order not found." if @order.nil?
  end

  def self.find_by_id_or_sha1(id)
    Order.find_by_id(id) || Order.find_by_sha1(id)
  end

  private

  def build_order_from_cart(params)
    @or.build_order_from_cart(current_cart)
    address_id = params[:order][:shipping_detail_id]
    @or.shipping_detail = current_user.shipping_details.find(address_id)
    @or.save
  end

end
