class CategoriesController < ApplicationController
  before_filter :admin_authorize, only: [:new, :create, :update, :edit]

  def show
    @category = Category.find_by_id(params[:id])
    @products = @category.products
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_store.categories.new(params[:category])
    if @category.save
      redirect_to store_category_path(@category.store, @category),
      notice: "Categories all the way down!"
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to store_category_path(@category.store, @category), 
      :notice => "Category updated."
    else
      render 'edit'
    end
  end

  private

end
