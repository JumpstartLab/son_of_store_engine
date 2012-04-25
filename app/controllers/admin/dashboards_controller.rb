# Shows all relevant administrator business intelligence information.
class Admin::DashboardsController < Admin::ApplicationController
  def show
    @statuses = Order.statuses
    @orders_by_status = Order.collect_by_status

    status = params[:status]

    if status
      @orders = @orders_by_status[status]
    else
      @orders = Order.all
    end
  end
end
