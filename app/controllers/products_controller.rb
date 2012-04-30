class ProductsController < ApplicationController

  before_filter :store_must_exist

  def index
    @products = current_store.products.active
    @categories = current_store.categories
  end

  def show
    @product = current_store.products.find_by_id(params[:id])
    @categories = @product.categories
  end

  private

  def store_must_exist
    unless current_store
      flash.now.notice = "A store does not exist at this address."
      render :text => "", layout: true
    end
  end
end
