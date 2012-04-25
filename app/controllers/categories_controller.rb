# Interface for 'browse by categories'
class CategoriesController < ApplicationController
  def show
    id = params[:id]
    @category = @store.categories.find(id)
    @products = @category.products
  end

  def index
    @categories = @store.categories.sort_by { |category| category.name}
  end
end
