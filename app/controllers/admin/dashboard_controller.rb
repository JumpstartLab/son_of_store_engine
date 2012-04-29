class Admin::DashboardController < Admin::ApplicationController

  def show
    @admins = store.admins
    @new_admin = store.store_admins.new
    @orders = Order.orders_by_status(params[:order_status])
    @categories = Category.all
  end

end
