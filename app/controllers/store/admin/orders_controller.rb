class Store::Admin::OrdersController < Store::Admin::BaseController

  def index
    @orders = current_store.orders
  end

  def show
    @order = current_store.orders.find(params[:id])
  end

  def update
    @order = current_store.orders.find_by_id(params[:id])
  end

end
