class Admin::OrdersController < Admin::ApplicationController

  def index
    @orders = Order.page(params[:page]).per(20)
  end

  def show
    @order = Order.find_by_sha1(params[:id])
  end

  def update
    @order = Order.find_by_sha1(params[:id])
  end

  def self.find_by_id_or_sha1(id)
    Order.find_by_id(id) || Order.find_by_sha1(id)
  end

end
