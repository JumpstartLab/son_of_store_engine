class DashboardController < ApplicationController
  before_filter :validate_store 
  #before_filter :user_may_manage, only: :show

  def show
    # if current_user is stocker
    # render stocker template
    # else if manager
    # render mang template
    # elsif owner
    # render owner template
    # else
    #  BOOM
    @orders = @store.orders
    @categories = @store.categories
    @products = @store.products
    @employees = @store.employees
  end

  private
  def validate_store
    @store = current_store
    return redirect_to root_path, 
           alert: "Oops, Store doesn't exist." unless @store
  end
end
