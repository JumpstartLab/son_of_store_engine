# Shows all active products in a store
class ProductsController < ApplicationController
  def index
    @products = @store.active_products
  end

  def show
    @product = @store.products.find(params[:id])
  end
end
