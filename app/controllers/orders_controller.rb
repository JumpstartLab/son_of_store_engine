class OrdersController < ApplicationController

  def new
    guard_new_order do
      if current_user.credit_cards.empty?
        flash.notice = flash.notice
        redirect_to new_credit_card_path(current_store.slug) and return
      elsif current_user.shipping_details.empty?
        flash.notice = flash.notice
        redirect_to new_shipping_detail_path(current_store.slug) and return
      end

      @order = Order.new()
      @order.credit_card = current_user.credit_cards.last
      @order.shipping_detail = current_user.shipping_details.last
    end
  end

  def index
    @orders = current_user.orders.desc
  end

  def create
    @order = Order.build_for(current_user, current_cart)
    @order.add_shipping_detail_for(current_user, params[:order])
    @order.set_cc_from_stripe_customer_token(params[:order][:customer_token])
    
    if @order.save && @order.charge(current_cart)
      redirect_to order_path(current_store.slug, @order.id),
        :notice => "Thank you for placing an order."
      OrderMailer.order_confirmation(@order).deliver
    else
      render :new
    end
  end

  def show
    @order = Order.find_by_id(params[:id])
    guard_show_order(@order) do
      @shipping_detail = @order.shipping_detail
      redirect_to root_path, :notice => "Order not found." if @order.nil?
    end
  end

private

  def guard_show_order(order, &block)
    if order.user.guest? || order.user == current_user
      block.call()
    else
      redirect_to root_path
    end
  end

  def guard_new_order(&block)
    if current_user
      block.call()
    else
      redirect_to signin_path(:checkout => true, :slug => current_store.slug)
    end
  end

end
