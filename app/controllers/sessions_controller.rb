class SessionsController < ApplicationController

  def new
  end

  def create
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(current_cart, user)
    else
      session[:cart_id] = current_cart.id
      invalid_email
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => "Logged out."
  end

private

  def successful_login(new_cart, user)
    if new_cart.has_products?
      existing_cart = user.carts.where(:store_id => current_store.id).first
      existing_cart.destroy if existing_cart
      user.carts << new_cart
    else
      new_cart.destroy
    end
    redirect_to store_path(current_store.slug)
    #redirect_to_last_page("Logged in!")
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
