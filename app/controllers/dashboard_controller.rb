class DashboardController < ApplicationController
  before_filter :validate_store 
  before_filter :user_may_manage, only: :show

  def show
    @orders = @store.orders.page(params[:page]).per(10)
    @categories = @store.categories
    @products = @store.products.page(params[:page]).per(10)
    @employees = @store.employees
  end

  private
  def validate_store
    @store = current_store
    return redirect_to root_path, 
           alert: "Oops, Store doesn't exist." unless @store
  end
end
