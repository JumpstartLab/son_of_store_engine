class CartsController < ApplicationController

  def show
  end

  def update
    @cart.add_product_by_id(params[:product])
    redirect_to cart_path
  end

  def destroy
    @cart.destroy
    redirect_to
  end
end