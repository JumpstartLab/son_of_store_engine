# Shows a user their orders
class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    notice = "You are not authorized to view that order."
    redirect_to root_path, :notice => notice unless @order.user == current_user
  end

  def index
    @orders = []
    @orders = Order.find_all_by_user_id(current_user.id) if current_user
  end

  def edit
    @order = Order.find(params[:id])
    session[:cart_id] = nil
  end

  def update
    order = Order.find(params[:id])
    order.update_with_addresses_and_card(params)
    OrderMailer.confirmation_email(order).deliver
    redirect_to order_path(order), :notice => "Order placed. Thank you!"
  end
end
