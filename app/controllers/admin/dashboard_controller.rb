class Admin::DashboardController < Admin::ApplicationController

  def show
    @orders = Order.orders_by_status(params[:order_status])
    @categories = Category.all
  end

end
