#
class CategoriesController < ApplicationController
  before_filter :lookup_category, :only => :show


    def index
      @categories = store_categories.all
    end

    def show
    end

    private

    def lookup_category
      @category = store_categories.find(params[:id])
      @products = @category.products
    end
    
    def store_categories
      Category.find_all_by_store_id(@current_store.id)
    end
end

