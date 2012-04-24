#
class ProductsController < ApplicationController
  before_filter :lookup_product, :only => :show
  # default_scope

  def index
    if params[:filtered].present?
      @products = Product.active.where(
        if Rails.env.production?
          ["title ILIKE ?", "%#{params[:filtered]}%"]
        else
          ["title LIKE ?", "%#{params[:filtered]}%"]
        end
        )
    else
      @products = Product.active.all
      @line_item = LineItem.new
    end
  end

  def show
  end

  private

  def lookup_product
    @product = Product.find(params[:id])
  end
end
