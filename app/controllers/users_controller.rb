# Users are generally handled by devise, unless creating a new billing.
class UsersController < ApplicationController
  def finalize_order
    order = Order.find(params[:billing][:order_id])
    order.finalize(params, current_user)
    session[:cart_id] = nil
    redirect_to order_path(order), :notice => "Order placed. Thank you!"
  end
end
