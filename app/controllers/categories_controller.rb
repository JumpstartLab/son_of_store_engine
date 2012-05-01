class CategoriesController < ApplicationController

  # def index
  #   @categories = Category.where(:store_id => store.id)
  # end

  def show
    @category = Category.find(params[:id])
    @categories = Category.where(:store_id => store.id)
    @products = @category.products.page(params[:page]).per(12)
  end

end
