class ProductsController < ApplicationController
  def index
    @products = if params[:category_id]
      Category.find_by_id(params[:category_id]).products
    else
      Product.where(:on_sale => true)
    end
  end

  def show
    @product = Product.find_by_id(params[:id])
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    params[:product][:price] = params[:product][:price].to_i * 100 if params[:product][:price]
    product = Product.new(params[:product])
    if product.save
      redirect_to products_path
    else
      @product = product
      render :action => "new"
    end
  end

  def destroy
    product = Product.find_by_id(params[:id])
    product.destroy
    redirect_to products_path
  end

  def edit
    @product = Product.find_by_id(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find_by_id(params[:id])
    @product.update_attributes(params[:product])
    if @product.save
      redirect_to product_path(@product)
    else
      render :action => "edit"
    end
  end

end