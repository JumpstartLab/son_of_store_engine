# Shows all active products in a store
class ProductsController < ApplicationController
  def index
    @products = @store.active_products.paginate(:page => params[:page])
  end

  def show
    @product = @store.products.find(params[:id])
  end

  def stock
    redirect_to admin_products_path(@store)
  end
end
