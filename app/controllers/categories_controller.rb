class CategoriesController < ApplicationController
  include ExtraCategoryMethods
  before_filter :lookup_category, :only => :show
  before_filter :lookup_products, :only => :show

  def index
    @categories = store_categories.all
  end

  def show
  end
end
