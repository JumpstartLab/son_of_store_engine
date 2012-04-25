# Allows administrators to manipulate categories and add products to them.
class Admin::CategoriesController < Admin::ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = @store.categories.create(params[:category])
    redirect_to admin_category_path(@store, @category),
      :notice => "Category created."
  end

  def show
    id = params[:id]
    @category = @store.categories.find(id)
    @products = ProductCategory.find_all_by_category_id(id).map(&:product)
  end

  def edit
    @category = @store.categories.find(params[:id])
  end

  def update
    @store.categories.find(params[:id]).update_attributes(params[:category])
    redirect_to admin_categories_path(@store)
  end

  def index
    @categories = @store.categories.all.sort_by { |category| category.name }
  end
end
