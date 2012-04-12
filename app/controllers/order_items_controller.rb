class OrderItemsController < ApplicationController
  before_filter :verify_is_admin
  def update
    order_item = OrderItem.find_by_id(params[:id])
    order_item.update_attributes(params[:order_item])
    redirect_to orders_path
  end
end
