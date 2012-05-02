class CategoriesController < ApplicationController

  # def index
  #   @categories = Category.where(:store_id => store.id)
  # end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
  end

end
