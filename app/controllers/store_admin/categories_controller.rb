# Allows restful actions for the categories
module StoreAdmin
  class CategoriesController < Controller
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
        redirect_to store_admin_categories_path
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
        redirect_to store_admin_categories_path
      else
        flash[:error] = "Update Failed."
        render 'edit'
      end
    end

    def destroy
      Category.find(params[:id]).destroy
      flash[:notice] = "Category deleted."
      redirect_to store_admin_categories_path
    end
  end
end