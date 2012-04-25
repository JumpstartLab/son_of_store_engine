class OrdersController < ApplicationController

  before_filter :require_login
  before_filter :belongs_to_current_user?, only: [:show]

  def new
    if current_user.credit_cards.empty?
      redirect_to new_credit_card_path(store_slug) and return
    end

    if current_user.shipping_details.empty?
      redirect_to new_shipping_detail_path(store_slug) and return
    end

    @credit_card = current_user.credit_cards.last
    @shipping_detail = current_user.shipping_details.last
    @order = Order.new
  end

  def index
    @orders = current_user.orders.desc
  end

  def create
    @order = current_user.orders.create
    build_order_from_cart(params)

    if @order.set_cc_from_stripe_customer_token(params[:order][:customer_token])
      redirect_to order_path(current_store.slug, @order.id),
        :notice => "Thank you for placing an order." if @order.charge(current_cart)
    else
      render :new
    end
  end

  def show
    @order = current_user.orders.find_by_id(params[:id])
    @shipping_detail = @order.shipping_detail
    redirect_to root_path, :notice => "Order not found." if @order.nil?
  end

private
  def belongs_to_current_user?
    unless Order.user_by_order_id(params[:id]) == current_user
      redirect_to root_path
    end
  end

  def build_order_from_cart(params)
    @order.build_order_from_cart(current_cart)
    address_id = params[:order][:shipping_detail_id]
    @order.shipping_detail = current_user.shipping_details.find(address_id)
    @order.save
  end

end
