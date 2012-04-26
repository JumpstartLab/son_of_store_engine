class SessionsController < ApplicationController

  def new
    if params[:checkout] == "true"
      render 'checkout_new' and return
    elsif current_store.nil?
      render 'new_global' and return
    end
  end

  def create
    #This needs to be fixed... login happens at root everytime now.

    cart_before_login = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(cart_before_login, user)
      redirect_to store_path(params[:slug]) and return
    else
      invalid_email
    end
  end

  def destroy
    logout
    if current_store
      redirect_to store_path(current_store.slug)
    else
      redirect_to root_url, :notice => "Logged out."
    end
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
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
