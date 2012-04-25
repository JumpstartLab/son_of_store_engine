# Shows all active products in a store
class ProductsController < ApplicationController
  def index
    @products = Product.find_all_by_retired(false)
  end

  def show
    @product = Product.find(params[:id])
  end
end
