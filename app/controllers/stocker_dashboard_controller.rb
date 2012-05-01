class StockerDashboardController < ApplicationController

  def show
    @store = current_store
    if current_user && current_user.may_stock?(@store)
      @products = current_store.products
    else
      redirect_to root_path
    end
  end
end
