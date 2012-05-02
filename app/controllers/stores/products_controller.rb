# module for the store_slug namespage
module Stores
  # to manage products for each store
  class ProductsController < ApplicationController
    before_filter :store_must_exist

    def index
      @products = current_store.active_products.order(
        "name").page(params[:page]).per(12)
      @products.accessible_by(current_ability)
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
end