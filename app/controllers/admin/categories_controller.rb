# Allows restful actions for the categories
module Admin
  class CategoriesController < Controller
    cache_sweeper :category_sweeper

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(params[:category])
      if @category.save
        flash[:notice] = "Category created."
        redirect_to admin_categories_path
      else
        flash[:error] = "Create failed."
        render 'edit'
      end
    end

    def edit
      @category = Category.find(params[:id])
    end

    def update
      @category = Category.find(params[:id])
      if @category.update_attributes(params[:category])
        flash[:notice] = "Category updated."
        redirect_to admin_categories_path
      else
        flash[:error] = "Update Failed."
        render 'edit'
      end
    end

    def destroy
      Category.destroy(params[:id])
      flash[:notice] = "Category deleted."
      redirect_to admin_categories_path
    end
  end
end