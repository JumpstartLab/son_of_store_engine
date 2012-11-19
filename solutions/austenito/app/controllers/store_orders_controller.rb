class StoreOrdersController < ApplicationController
  before_filter :user_may_manage, only: :index
  def index
    @orders = current_store.orders.page(params[:page])
  end
end
