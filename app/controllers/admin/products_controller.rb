# Restful actions for products
module Admin
  class ProductsController < Controller
    cache_sweeper :product_sweeper

    include ProductsActions

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(params[:product])
      if @product.save()
        redirect_to admin_products_path(), :notice => "Product created."
      else
        render 'new'
      end
    end

    def destroy
      product = Product.find(params[:id])
      product.destroy
      redirect_to admin_products_path, :notice => "Product Removed"
    end

    def edit
      @product = Product.find(params[:id])
    end

    def update
      @product = Product.find(params[:id])
      if @product.update_attributes(params[:product])
        redirect_to admin_products_path(), :notice => "Product updated."
      else
        render 'edit'
      end
    end

  end
end