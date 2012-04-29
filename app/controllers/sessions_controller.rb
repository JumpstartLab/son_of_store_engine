class SessionsController < ApplicationController
  include SessionHelpers

  def new
    render 'checkout_new' if params[:slug] && params[:checkout]
  end

  def create
    carts = current_carts
    if user = login(params[:email], params[:password], params[:remember_me])
      carts.each do |cart|
        transfer_cart_to_user(cart, user)
      end

      if params[:checkout] == "true"
        redirect_to new_order_path(params[:slug]), :notice => "You have been signed in."
      else
        redirect_to successful_login_path, :notice => "You have been signed in."
      end
    else
      invalid_login_credentials
      render :new
    end
  end

  def destroy
    logout
    redirect_to successful_logout_path, :notice => "You have been logged out."
  end

private

  def invalid_login_credentials
    flash.now.alert = "Email or password was invalid."
  end
end
