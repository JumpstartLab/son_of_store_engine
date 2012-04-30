class Store::Admin::StatusesController < Store::Admin::BaseController

  def create
    # raise params.inspect
  end

  def update
    @order_status = OrderStatus.find_by_order_id(params[:order_id])
    @order_status.update_status(params[:new_status])
    redirect_to admin_store_path(current_store), :notice => "Status updated!"
  end

end