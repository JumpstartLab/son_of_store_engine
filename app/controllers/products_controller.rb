class ProductsController < ApplicationController

  def index
    @categories = Category.where(:store_id => store.id)
    #@store = Store.where(:url_name => params[:url_name]).first
    @products = Product.where(:store_id => store.id)
  end

  def show
    @product = Product.find_by_id(params[:id])
    @categories = @product.categories
  end

end