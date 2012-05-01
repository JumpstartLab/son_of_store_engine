class CheckoutController < ApplicationController
  before_filter :set_checking_out, :only => :new

  def new
    if current_user then redirect_to new_store_order_path(current_store) end
    if @cart.items.count == 0 then redirect_to root_path end
  end

  private

  #TODO: Factor this checkout_store_id out
  def set_checking_out
    session[:checking_out] = true
    session[:checkout_store_id] = @cart.products.first.store.id rescue nil
  end
end
