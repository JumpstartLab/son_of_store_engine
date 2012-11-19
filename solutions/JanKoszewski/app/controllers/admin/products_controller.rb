# Allows administrators to CRUD items and retire them.
class Admin::ProductsController < Admin::ApplicationController
  load_and_authorize_resource

  def index
    @products = @store.products.order('title').paginate(
      :page => params[:page],
      :per_page => 25)
  end

  def show
    @categories = @store.categories
    @product = @store.products.find(params[:id])
  end

  def new
    @product = @store.products.new
  end

  def create
    product = @store.products.create(params[:product])
    flash[:notice] = "Product created."
    redirect_to admin_product_path(@store, product)
  end

  def edit
    @categories = @store.categories.all
    @product = @store.products.find(params[:id])
  end

  def update
    Product.find(params[:id]).update_attributes(params[:product])
    redirect_to admin_products_path, :notice => 'Product updated'
  end

  def retire_product
    product = @store.products.find(params[:product_id])
    if product
      product.retire
      notice = "Product #{product.title} retired."
    end

    redirect_to admin_products_path(@store), :notice => notice
  end
end
