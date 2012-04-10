class CartItemsController < ApplicationController

  def destroy
    CartItem.find_by_id(params[:id]).destroy
    redirect_to cart_path
  end
end
