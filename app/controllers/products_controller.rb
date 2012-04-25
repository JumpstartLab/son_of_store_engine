class ProductsController < ApplicationController
  before_filter :verify_store_status

  def index
    @products = current_store.products.active
    @categories = current_store.categories
  end

  def show
    @product = current_store.products.find_by_id(params[:id])
    @categories = @product.categories
  end
end