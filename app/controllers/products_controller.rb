class ProductsController < ApplicationController

  def index
    @categories = Category.where(:store_id => store.id)
    @products = Product.where(:store_id => store.id)
  end

  def show
    @product = Product.find_by_id(params[:id])
    @categories = @product.categories
  end

end
