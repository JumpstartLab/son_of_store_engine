class Admin::DashboardController < Admin::ApplicationController
  skip_before_filter :is_admin?, :only => ['show']
  before_filter :is_store_admin?

  def show
    @admins = store.admins
    @new_admin = store.store_admins.new
    @orders = Order.orders_by_status(params[:order_status])
    @categories = Category.all
  end

end
