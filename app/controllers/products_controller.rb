class ProductsController < ApplicationController

  before_filter :admin_authorize,
                only: [:destroy, :edit, :update, :create, :new]
  before_filter :validate_store_path

  def index
    if params[:search] && params[:search].length > 0
      @products = current_store.products.active.find_by(params[:search])
      json_responder
    else
      @products = current_store.products.active
      json_responder
    end
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

  def json_responder
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def validate_store_path
    unless current_store
      redirect_to root_path, notice: "Could not find the store you were looking for. Try one of these!"
    end
  end
end
