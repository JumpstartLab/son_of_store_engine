module Stores
  class CategoriesController < ApplicationController

    def show
      @categories = current_store.categories
      @category = @categories.find(params[:id])
      # @products = @category.active_products
      @products = @category.active_products.order("name").page(params[:page]).per(12)

    end

  end
end