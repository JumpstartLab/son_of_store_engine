class CategoriesController < ApplicationController
  include ExtraCategoryMethods
  before_filter :lookup_category, :only => :show
  before_filter :lookup_products, :only => :show

  def index
    @categories = store_categories.page(params[:page]).per(ITEMS_PER_PAGE)
  end

  def show
  end
end
