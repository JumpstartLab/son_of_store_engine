class ProductsController < ApplicationController
  before_filter :is_store_approved?, only: [ :show, :index ]

#Post.where(:published => true).paginate(:page => params[:page]).order('id DESC')
  def index
    @categories = store.categories
    @products = store.products.active.page(params[:page]).per(12)
  end

  def show
    @product = store.products.find_by_id(params[:id])
    @categories = @product.categories
  end

end
