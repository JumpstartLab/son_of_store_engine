class CartItemsController < ApplicationController
  def create
    product = Product.find_by_id(params[:product_id])
    if product.activity == true
      increment
    else
      redirect_to store_product_path(product.store, product),
      :alert => "Sorry, this product is retired."
    end
  end

  def increment
    @cart.add_or_increment_by_product(params[:product_id])
      respond_to do |format|
        format.html { redirect_to store_cart_path(current_store), 
                      notice: 'Added to cart.' }
        format.js
      end
  end

  def edit
    @cart_item = CartItem.find(params[:id])
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.update_attributes(params[:cart_item])
    delete_on_zero
    redirect_to store_cart_path(current_store)
  end

  def delete_on_zero
    if @cart_item.quantity == 0
      @cart_item.destroy
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to store_cart_path(current_store)
  end
end
