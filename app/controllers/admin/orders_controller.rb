# Allows administrators to see and edit orders, removing items if pending.
class Admin::OrdersController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @orders = @store.orders
  end

  def show
    @order = @store.orders.find(params[:id])
  end

  def edit
    @order = @store.orders.find(params[:id])
  end

  def update
    @store.orders.find(params[:id]).update_attributes(params[:order])
    redirect_to :back
  end

  def destroy
    OrderItem.find(params[:item_id]).destroy
    notice = "Item deleted."
    redirect_to admin_order_path(@store.orders.find(params[:id])),
      :notice => notice
  end
end
