# module for the store_slug namespage
module Stores
  # to show cart products for each store
  class CartProductsController < ApplicationController

    def new
      if current_cart.add_product_by_id(params[:id])
        redirect_to store_cart_path
      else
        redirect_to store_cart_path, :notice => "Can't add product to cart."
      end
    end

    def destroy
      current_cart.cart_products.find(params[:id]).destroy
      redirect_to store_cart_path
    end

    def update
      current_cart_product = current_cart.cart_products.find(params[:id])
      current_cart_product.update_quantity(params[:cart_product][:quantity])
      redirect_to store_cart_path
    end
  end
end