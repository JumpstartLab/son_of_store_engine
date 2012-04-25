class CheckoutController < ApplicationController

  def new
    if current_user then redirect_to new_order_path end
    if @cart.items.count == 0 then redirect_to root_path end
  end
end
