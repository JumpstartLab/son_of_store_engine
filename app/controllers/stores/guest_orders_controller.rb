module Stores
  class GuestOrdersController < ApplicationController

    helper_method :user

    def new
      @shipping_detail = ShippingDetail.new()
      @credit_card = CreditCard.new()
    end

    def show
      @order = current_store.orders.find(params[:id])
    end

    def create
      @order = Orders.build_for_guest_user(user, current_cart, params)

      if @order.save && @order.charge(current_cart)
        redirect_to order_path(current_store.slug, @order.id),
          notice: "Thank you for placing an order."
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
end