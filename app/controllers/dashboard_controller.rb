class DashboardController < ApplicationController
  before_filter :admin_authorize
  before_filter :find_store, except: :index

  def show
    @orders = @store.orders
    @categories = @store.categories
    @products = @store.products
  end

  def index
    @stores = Store.all
  end

  private
  def find_store
    @store = Store.find_by_slug(params[:store_id])
  end
end
