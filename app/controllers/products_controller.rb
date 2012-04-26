class ProductsController < ApplicationController

  before_filter :is_store_approved?, only: [ :show, :index ]

  def index
    # @products = Product.active.all
    # @categories = Category.all
    #raise params.inspect
    @categories = Category.where(:store_id => store.id)
    #@store = Store.where(:url_name => params[:url_name]).first
    @products = Product.where(:store_id => store.id)
  end

  def show
    @product = Product.find_by_id(params[:id])
    @categories = @product.categories
  end

  private

  def is_store_approved?
    redirect_to stores_path, 
      notice: "Store not found! Browse some others!" unless store.approved? && store.enabled?
  end
end