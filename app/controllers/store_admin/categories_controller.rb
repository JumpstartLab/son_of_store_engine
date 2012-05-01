#
class StoreAdmin::CategoriesController < ApplicationController
  before_filter :lookup_category, :only => [:show, :edit, :destroy, :update]
  before_filter :confirm_has_store_admin_access


    def index
      @categories = store_categories.all
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

    private

    def lookup_category
      @category = store_categories.where(id: params[:id]).first
      @products = @category.products
    end

    def store_categories
      Category.where(store_id: @current_store.id)
    end
    
    def confirm_has_store_admin_access
      redirect_to root_path unless current_user.is_admin_of(@current_store)
    end
end

