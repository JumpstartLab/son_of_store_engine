class CartProductsController < ApplicationController

  def new
    if current_cart.add_product_by_id(params[:product_id])
      redirect_to :back,
        :notice => "Product added to cart!"
    else
      redirect_to cart_path,
        :notice => "This product has been retired."
    end
  end

  def destroy
    current_cart.cart_products.find(params[:id]).destroy
    redirect_to :back,
      :notice => "Product removed from cart!"
  end

  def update
    current_cart_product = current_cart.cart_products.find(params[:id])
    current_cart_product.update_quantity(params[:cart_product][:quantity])
    redirect_to :back,
      :notice => "Your cart was updated!"
  end
end
