# Interface to manage carts for guests and users
class CartsController < ApplicationController
  before_filter :find_cart_from_session

  def show
  end

  def update
    if params[:cart] && params[:cart][:order_item]
      item = OrderItem.find(params[:cart][:order_item][:id])
      item.update_attributes(params[:cart][:order_item])
    else
      @cart.add_product_by_id(params[:product_id])
    end
    redirect_to cart_path
  end

  def find_cart_from_session
    @cart = Cart.find(session[:cart_id])
  end

  def checkout
    order = Order.create_from_cart(@cart)
    order.update_attributes(:user_id => current_user.id)
    redirect_to billing_path(:order_id => order.id)
  end
end
