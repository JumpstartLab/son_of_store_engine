class CartsController < ApplicationController
  before_filter { @cart = find_or_create_cart_from_session }

  def show
  end

  def update
    @cart.add_product_by_id(params[:product])
    redirect_to cart_path
  end

private

  def find_or_create_cart_from_session
    cart = Cart.find_by_id(session[:cart_id])
    cart ||= Cart.create(:user => current_user)
    session[:cart_id] = cart.id
    cart
  end
end