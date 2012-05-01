class ProductsController < ApplicationController
  before_filter :store_disabled
  before_filter :user_may_manage,
                only: [:destroy, :edit, :update, :create, :new]
  before_filter :store_required
  before_filter :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @admin = admin?
    if params[:search] && params[:search].length > 0
      session[:search] = true
      @products = current_store.products.active.find_by(params[:search])
    else
      session[:search] = false 
      @products = current_store.products.page(params[:page])
    end
    @top_selling = Product.top_selling_for_store(current_store)
    @categories = current_store.categories
  end

  def new
    @product = current_store.products.new
  end

  def create
    @product = current_store.products.new(params[:product])
    if @product.save
      redirect_to store_dashboard_path(@product.store), 
      :notice => "Product #{@product.title} created."
    else
      flash[:error] = @product.errors.full_messages.join(", ")
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @product.update_attributes(params[:product])
      redirect_to store_dashboard_path(@product.store), 
      :notice => "Product #{@product.title} updated."
    else
      flash[:error] = @product.errors.full_messages.join(", ")
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, :alert => "Product deleted."
  end

  private

  helper_method :searching?
  def searching?
    session[:search]
  end

  def find_product 
    @product = current_store.products.find(params[:id])
  end

  def store_disabled
    if current_store && current_store.disabled?
      render "shared/store_disabled"
    end
  end
end
