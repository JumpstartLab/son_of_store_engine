class CartProductsController < ApplicationController

  def new
    # raise current_cart.inspect
    if current_cart.add_product_by_id(params[:id])
      redirect_to cart_path
    else
      redirect_to cart_path, :notice => "Can't add product to cart."
    end
  end

  def destroy
    current_cart.cart_products.find(params[:id]).destroy
    redirect_to cart_path
  end

  def update
    current_cart_product = current_cart.cart_products.find(params[:id])
    current_cart_product.update_quantity(params[:cart_product][:quantity])
    redirect_to cart_path
  end
end
