class Store::CategoriesController < ApplicationController

  def show
    @category = current_store.categories.find(params[:id])
    @categories = Category.all
    @products = @category.products
  end

end
