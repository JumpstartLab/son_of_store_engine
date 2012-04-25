# Restful actions for products
class ProductsController < ApplicationController
  
  include ProductsActions

  def show
    @product = Product.find(params[:id])
    @can_rate = can_rate(params[:id])
  end

private

  def can_rate(id) ## Users can only rate if they have purchased the product
    if current_user && current_user.products.find_by_id(id)
      true
    end
  end

end
