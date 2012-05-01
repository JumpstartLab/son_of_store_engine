class SessionsController < ApplicationController
  include SessionHelpers

  def new
    render 'checkout_new' if params[:checkout]
  end

  def create
    carts = current_carts
    if user = login(params[:email], params[:password], params[:remember_me])
      carts.each { |cart| transfer_cart_to_user(cart, user) }
      redirect_to return_path, :notice => "You have been signed in."    
    else
      invalid_login_credentials
      render :new
    end
  end

  def destroy
    logout
    redirect_to store_path(params[:slug]), :notice => "You have been logged out."
  end

private

  def invalid_login_credentials
    flash.now.alert = "Email or password was invalid."
  end
end
