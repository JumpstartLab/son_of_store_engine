class Store::Admin::StatusesController < Store::Admin::BaseController

  def create
  end

  def update
    @order_status = OrderStatus.find_by_order_id(params[:order_id])
    @order_status.update_status(params[:new_status])
    redirect_to admin_path, :notice => "Status updated!"
  end

end