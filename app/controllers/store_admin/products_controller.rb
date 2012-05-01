class StoreAdmin::ProductsController < ApplicationController
  include ExtraProductMethods
  before_filter :lookup_product, except: [:index, :new, :create]
  before_filter :confirm_has_store_admin_or_stocker_access

  cache_sweeper :product_sweeper

  def index
    @products = store_products.page(params[:page]).per(10)
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
      redirect_to admin_products_path(@current_store), notice: notice
    else
      render action: "new"
    end
  end

  def destroy
    Product.destroy(@product)
    redirect_to admin_products_path(@current_store)
  end

  def retire
    product = Product.find(params[:id])
    if product.retired?
      product.make_active_again
    else
      product.retire
    end
    redirect_to admin_products_path, notice: "\'#{product.title}\' was retired"
  end


  def edit
  end

  def update
    @product.update_attributes(params[:product])
    redirect_to admin_products_path(@current_store), notice: "\'#{@product.title}\' has been updated"
  end

end
