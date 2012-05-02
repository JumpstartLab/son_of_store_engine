# module for the store_slug namespage
module Stores
  # to show categories for each store
  class CategoriesController < ApplicationController

    def show
      @category = current_store.categories.find(params[:id])
      @categories = current_store.categories
      @products = @category.products
    end

  end
end