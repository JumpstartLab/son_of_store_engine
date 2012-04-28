# Shows all relevant administrator business intelligence information.
class Admin::DashboardsController < Admin::ApplicationController
  def show
    @statuses = @store.orders.statuses
    @orders_by_status = @store.orders.collect_by_status
    status = params[:status]

    if status
      @orders = @orders_by_status[status]
    else
      @orders = @store.orders.all
    end
  end
end
