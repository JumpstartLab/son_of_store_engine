module Stores
  class CategoriesController < ApplicationController

    def show
      @category = current_store.categories.find(params[:id])
      @categories = current_store.categories
      @products = @category.products
    end

  end
end