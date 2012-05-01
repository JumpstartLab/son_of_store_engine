#
class StoreAdmin::ProductsController < ApplicationController
  before_filter :lookup_product, except: [:index, :new, :create]
  before_filter :confirm_has_store_admin_access

  cache_sweeper :product_sweeper

  def index
    @products = store_products
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    @product.store_id = @current_store.id
    if @product.save
      notice = 'Product was successfully created.'
      redirect_to admin_product_path(@current_store, @product), notice: notice
    else
      render action: "new"
    end
  end

  def destroy
    Product.destroy(@product)
    redirect_to admin_products_path
  end

  def retire
    product = Product.find(params[:id])
    if product.retired?
      product.make_active_again
    else
      product.retire
    end
    redirect_to admin_products_path
  end


  def edit
  end

  def update
    @product.update_attributes(params[:product])
    redirect_to admin_product_path(@product)
  end

  private

  def lookup_product
    @product = store_products.where(id: params[:id]).first
  end

  def store_products
    Product.where(store_id: @current_store.id)
  end

  def confirm_has_store_admin_access
    redirect_to root_path unless current_user.is_admin_of(@current_store)
  end
end
