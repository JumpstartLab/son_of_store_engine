class Admin::StatusesController < Admin::ApplicationController

  def create
  end

  def update
    @order_status = OrderStatus.find_by_order_id(params[:order_id])
    @order_status.update_status(params[:new_status])
    redirect_to_last_page("Status updated!")
  end

end
