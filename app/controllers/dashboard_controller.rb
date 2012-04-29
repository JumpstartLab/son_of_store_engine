class DashboardController < ApplicationController
  before_filter :validate_store, except: :index
  before_filter :user_may_manage, only: :show
  before_filter :admin_required, only: :index

  def show
    @orders = @store.orders
    @categories = @store.categories
    @products = @store.products
  end

  def index
    @stores = Store.all
  end

  private
  def validate_store
    @store = current_store
    return redirect_to root_path, 
           alert: "Oops, Store doesn't exist." unless @store
  end
end
