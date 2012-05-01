class StoreAdmin::CategoriesController < ApplicationController
  include ExtraCategoryMethods
  before_filter :lookup_category, :only => [:show, :edit, :destroy, :update]
  before_filter :lookup_products, :only => [:show, :edit, :destroy, :update]
  before_filter :confirm_has_store_admin_access

  def index
    @categories = store_categories.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new(params[:category])
    category.store = @current_store
    category.save
    redirect_to admin_category_path(@current_store, category)
  end

  def destroy
    Category.destroy(@category)
    redirect_to admin_categories_path(@current_store)
  end

  def edit
  end

  def update
    @category.update_attributes(params[:category])
    redirect_to admin_category_path(@current_store, @category)
  end

end

