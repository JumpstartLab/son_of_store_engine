class ProductsController < ApplicationController

  def index
    @categories = store.categories
    @products = store.products
  end

  def show
    @product = Product.find_by_id(params[:id])
    @categories = @product.categories
  end

end
