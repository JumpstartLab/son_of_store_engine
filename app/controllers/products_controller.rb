class ProductsController < ApplicationController
  before_filter :admin_required,
                only: [:destroy, :edit, :update, :create, :new]
  before_filter :store_required

  def index
    @admin = admin?
    if params[:search] && params[:search].length > 0
      session[:search] = true
      @products = current_store.products.active.find_by(params[:search])
    else
      session[:search] = false 
      @products = current_store.products.page(params[:page])
    end
    @top_selling = current_store.products.top_selling
    @categories = current_store.categories
  end

  def new
    @product = current_store.products.new
  end

  def create
    @product = current_store.products.new(params[:product])
    if @product.save
      redirect_to store_product_path(@product.store, @product), 
      :notice => "Product created."
    else
      render 'new'
    end
  end

  def show
    @product = current_store.products.find(params[:id])
  end

  def edit
    @product = current_store.products.find(params[:id])
  end

  def update
    @product = current_store.products.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to store_product_path(@product.store, @product), 
      :notice => "Product updated."
    else
      render 'edit'
    end
  end

  def destroy
    @product = current_store.products.find(params[:id])
    @product.destroy
    redirect_to products_path, :alert => "Product deleted."
  end

  private

  helper_method :searching?
  def searching?
    session[:search]
  end
end
