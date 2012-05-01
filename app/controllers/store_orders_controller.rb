class StoreOrdersController < ApplicationController
  def index
    @orders = current_store.orders.page(params[:page]).per(15)
  end
end
