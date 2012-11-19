# Shows all relevant administrator business intelligence information.
class Admin::DashboardsController < Admin::ApplicationController
  load_and_authorize_resource :store

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

  def edit
  end

  def update
    if @store.update_attributes(params[:store])
      redirect_to admin_dashboard_path(@store), :notice => 'Updated Store'
    else
      render 'edit'
    end
  end
end
