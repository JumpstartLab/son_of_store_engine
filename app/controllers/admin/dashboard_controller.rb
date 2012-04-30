class Admin::DashboardController < Admin::ApplicationController

  def show
    authorize! :read, @orders
    @orders = current_store.orders.find_by_status(params[:order_status])
    @categories = current_store.categories
  end
end
