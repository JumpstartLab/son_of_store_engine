class GuestOrdersController < ApplicationController

  before_filter :belongs_to_current_user?, only: [:show]

  def new
    @user = GuestUser.new()
    @shipping_detail = ShippingDetail.new()
    @credit_card = CreditCard.new()
  end

  def create
    user = GuestUser.create(params[:guest_user])
    user.shipping_details.create(params[:shipping_detail])
    @cc.add_details_from_stripe_card_token(
      params[:credit_card][:stripe_card_token] )
    @order = Order.create_for(current_user, current_cart, params[:order])

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

  def is_logged_in?
    redirect_to new_guest_order_path unless current_user
  end


end
