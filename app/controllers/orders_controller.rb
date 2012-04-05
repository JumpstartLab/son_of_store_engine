class OrdersController < ApplicationController
  def index
    @orders = Order.all
    @statuses = Order.count(:all, :group => :status)
  end
end
