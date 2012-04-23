class CartItemsController < ApplicationController
  def update
    cart_item = CartItem.find_by_id(params[:id])
    cart_item.update_attributes(params[:cart_item])
    redirect_to cart_path
  end

  def destroy
    CartItem.find_by_id(params[:id]).destroy
    redirect_to cart_path
  end
end
