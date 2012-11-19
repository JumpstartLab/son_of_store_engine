# Interface to manage carts for guests and users
class CartsController < ApplicationController
  before_filter :find_cart_from_session

  def show
  end

  def prompt
    redirect_to checkout_path if current_user
  end

  def update
    # raise params.inspect
    if params[:order_item] #&& params[:cart][:order_item]
      item = OrderItem.find(params[:order_item][:id])
      item.update_attributes(params[:order_item])
    else
      @cart.add_product_by_id(params[:product_id])
    end

    redirect_to cart_path(@store)
  end

  def find_cart_from_session
    @cart = Cart.find(session[:cart_id])
  end

  def checkout
    order = Order.create_from_cart(@cart, @store)
    order.update_attributes(:user_id => current_user.id) if current_user
    redirect_to edit_order_path(@store, order)
  end
end
