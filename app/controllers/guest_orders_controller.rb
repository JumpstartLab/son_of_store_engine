class GuestOrdersController < ApplicationController

  helper_method :user

  def new
    @shipping_detail = ShippingDetail.new()
    @credit_card = CreditCard.new()
  end

  def create
    @order = Order.create_for(user, current_cart)
    @order.shipping_detail = user.shipping_details.build(params[:shipping_detail])
    @order.credit_card = CreditCard.build_from_stripe_for(user, params[:credit_card])
    if @order.save
      redirect_to order_path(current_store.slug, @order.id),
        :notice => "Thank you for placing an order." if @order.charge(current_cart)
      OrderMailer.order_confirmation(@order).deliver
    else
      render :new
    end
  end

private
  def user
    @user ||= GuestUser.create(params[:guest_user])
  end
end
