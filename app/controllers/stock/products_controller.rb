# Restful actions for products
module Stock
  class ProductsController < ApplicationController
    before_filter :require_login
    before_filter :confirm_stocker

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
  private

    def confirm_stocker
      sr = current_tenant.store_roles.find_by_user_id(current_user.id)
      unless sr.stocker?
        flash[:alert] = "You are not a store stocker!"
        redirect_to root_url
      end
    end
  end
end