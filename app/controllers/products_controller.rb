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
      @products = active_store_products.all
      @line_item = LineItem.new
    end
  end

  def show
  end

  private

  def lookup_product
    @product = store_products.where(id: params[:id]).first
  end

  def active_store_products
    Product.active.where(store_id: @current_store.id)
  end

  def store_products
    Product.where(store_id: @current_store.id)
  end

  def store_enabled
    if !@current_store || !@current_store.approved?
      render "errors/404", :status => 404, :domain => nil
    elsif @current_store.approved? && !@current_store.enabled
      notice = "This site is currently down for maintenance"
      redirect_to root_path, notice: notice
    end
  end
end
