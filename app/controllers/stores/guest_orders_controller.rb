module Stores
  class GuestOrdersController < ApplicationController

    helper_method :user

    def new
      @user = User.new
      @order = Order.new
      @order.build_shipping_detail
      @order.build_credit_card
    end

    def show
      @order = current_store.orders.find(params[:id])
    end

    def create
      @order = Order.build_for_guest_user(user, current_cart, params)

      if @order.save! && @order.charge(current_cart)
        redirect_to user_order_path(@order.id),
          notice: "Thank you for placing an order."
        @order.send_order_confirmation
      else
        render :new
      end
    end

    private

    def user
      @user ||= GuestUser.create!(params[:user])
    end
  end
end