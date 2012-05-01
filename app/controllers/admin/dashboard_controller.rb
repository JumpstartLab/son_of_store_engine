class Admin::DashboardController < Admin::ApplicationController

  def show
    @admins = store.admins
    @stockers = store.stockers
    @new_admin = store.store_admins.new(stocker: false)
    @new_stocker = store.store_admins.new(stocker: true)
    @orders = Order.orders_by_status(params[:order_status]).page(params[:page]).per(20)
    @categories = store.categories
  end

end
