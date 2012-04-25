#
class ProductsController < ApplicationController
  before_filter :lookup_product, :only => :show
  before_filter :store_enabled
  # default_scope

  def index
    if params[:filtered].present?
      @products = active_store_products.where(
        if Rails.env.production?
          ["title ILIKE ?", "%#{params[:filtered]}%"]
        else
          ["title LIKE ?", "%#{params[:filtered]}%"]
        end
        )
    else
      @products = active_store_products
      @line_item = LineItem.new
    end
  end

  def show
  end

  private

  def lookup_product
    @product = store_products.find(params[:id])
  end
  
  def active_store_products
    Product.active.find_all_by_store_id(@current_store.id)
  end
  
  def store_products
    Product.find_all_by_store_id(@current_store.id)
  end
  
  def store_enabled
    redirect_to root_path, notice: "This store does not exist" unless @current_store.enabled
  end
end
