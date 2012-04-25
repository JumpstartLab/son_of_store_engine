#
class Admin::CategoriesController < ApplicationController
  before_filter :lookup_category, :only => [:show, :edit, :destroy, :update]
  before_filter :require_admin


    def index
      @categories = Category.all
    end

    def show
    end

    def new
      @category = Category.new
    end

    def create
      category = Category.new(params[:category])
      category.save
      redirect_to admin_category_path(@store, category)
    end

    def destroy
      Category.destroy(@category)
      redirect_to admin_categories_path(@store)
    end

    def edit
    end

    def update
      @category.update_attributes(params[:category])
      redirect_to admin_category_path(@store, @category)
    end

    private

    def lookup_category
      @category = Category.find(params[:id])
      @products = @category.products
    end
end

