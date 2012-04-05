class OrdersController < ApplicationController
  def index
    @orders = Order.all
    @orders = @orders.status(params[:filter]) unless params[:filter].blank?
    @filters = Order.select(:status).uniq
    @statuses = Order.count(:all, :group => :status)
  end
end
