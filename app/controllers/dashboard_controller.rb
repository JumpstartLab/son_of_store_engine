class DashboardController < ApplicationController
  before_filter :user_may_manage, only: :show
  before_filter :admin_required, only: :index

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
