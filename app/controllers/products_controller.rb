class ProductsController < ApplicationController
  def index
    @products = if params[:category_id]
      Category.find_by_id(params[:category_id]).products
    else
      puts "BLAH!"
      Product.all
    end
  end
  def show
    @product = Product.find_by_id(params[:id])
  end
end
