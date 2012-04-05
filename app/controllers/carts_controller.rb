class CartsController < ApplicationController
  def show
    @cart = Cart.find_by_user_id(current_user)
    @cart ||= Cart.new(:user => current_user)
    if params[:product]
      update
    end
  end

  def update
    @product = Product.find_by_id(params[:product])
    @cart.add_item(@product)
    @cart.save
  end
end