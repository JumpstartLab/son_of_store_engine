class Admin::OrdersController < Admin::ApplicationController

  def index
    @orders = Order.page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find_by_id(params[:id])
  end

end
