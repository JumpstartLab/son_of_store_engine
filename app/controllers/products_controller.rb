class ProductsController < ApplicationController
  def index
    @products = if params[:category_id]
      Category.find_by_id(params[:category_id]).products
    else
      Product.all
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
    @categories = Category.all
    params[:product][:price] = params[:product][:price].to_i * 100
    product = Product.new(params[:product])
    product.categories = @categories.select do |category|
      params[:category_ids].include? category.id.to_s
    end
    product.save
    redirect_to products_path
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
    redirect_to products_path
  end

end