class DashboardController < ApplicationController
  before_filter :validate_store 
  before_filter :user_may_manage, only: :show

  def show
    @orders = @store.orders
    @categories = @store.categories
    @products = @store.products
  end

  private
  def validate_store
    @store = current_store
    return redirect_to root_path, 
           alert: "Oops, Store doesn't exist." unless @store
  end
end
