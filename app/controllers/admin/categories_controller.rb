# Allows administrators to manipulate categories and add products to them.
class Admin::CategoriesController < Admin::ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.create(params[:category])
    redirect_to admin_category_path(@category), :notice => "Category created."
  end

  def show
    id = params[:id]
    @category = Category.find(id)
    @products = ProductCategory.find_all_by_category_id(id).map(&:product)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    Category.find(params[:id]).update_attributes(params[:category])
    redirect_to admin_categories_path
  end

  def index
    @categories = Category.all.sort_by { |category| category.name }
  end
end
