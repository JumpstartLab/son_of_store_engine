class DashboardController < ApplicationController
  before_filter :admin_authorize
  def show
    store = current_store
    if store.nil?
      redirect_to root_path, :alert => "Oops, Store doesn't exist."
    else
      @orders = store.orders
      @categories = store.categories
      @products = store.products
    end
  end

  def index
    @stores = Store.all
  end

  private
end
