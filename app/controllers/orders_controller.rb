# OrdersController that isn't within any admin/store module
class OrdersController < ApplicationController

  def index
    @orders = current_user.orders.desc
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
      redirect_to root_path, :notice => 'Sorry. You can only view
         orders which you have placed.'
    end
  end
end