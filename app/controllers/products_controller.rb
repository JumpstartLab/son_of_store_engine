class ProductsController < ApplicationController
  include ExtraProductMethods
  before_filter :lookup_product, :only => :show
  before_filter :store_enabled
  # default_scope

  def index
    @active_store_products = active_store_products
    if params[:filtered].present?
      @products = active_store_products.where(
        if Rails.env.production?
          ["title ILIKE ?", "%#{params[:filtered]}%"]
      else
        ["title LIKE ?", "%#{params[:filtered]}%"]
      end
      ).page(params[:page]).per(ITEMS_PER_PAGE)
    else
      @products = active_store_products.page(params[:page]).per(ITEMS_PER_PAGE)
      @line_item = LineItem.new
    end
  end

  def show
  end

end
