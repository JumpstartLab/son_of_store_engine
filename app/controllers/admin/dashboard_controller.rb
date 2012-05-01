class Admin::DashboardController < Admin::ApplicationController
  #skip_before_filter :is_admin?, :only => ['show']
  #before_filter :is_store_admin?

  def show
    @admins = store.admins
    @stockers = store.stockers
    @new_admin = store.store_admins.new(stocker: false)
    @new_stocker = store.store_admins.new(stocker: true)
    @orders = Order.orders_by_status(params[:order_status])
    @categories = store.categories
  end

end
