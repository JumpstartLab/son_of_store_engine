class DashboardController < ApplicationController
  before_filter :admin_authorize
  def show
    @orders = current_store.orders
    @categories = current_store.categories
    @products = current_store.products
  end

  def index
    @stores = Store.all
  end

  private
end
