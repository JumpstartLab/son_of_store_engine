class SessionsController < ApplicationController

  def new
  end

  def create
    cart_before_login = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(cart_before_login, user)
    else
      session[:cart_id] = cart.id
      invalid_email
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out."
  end

private

  def successful_login(cart_before_login, user)
    if cart_before_login.has_products?
      existing_cart = user.carts.where(:store_id => current_store.id).first
      existing_cart.destroy if existing_cart
      user.carts << cart_before_login
    else
      cart_before_login.destroy
    end
    redirect_to store_path(current_store.slug)
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
