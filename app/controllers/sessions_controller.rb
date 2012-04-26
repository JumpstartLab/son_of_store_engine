class SessionsController < ApplicationController

  def new
    if current_store.nil?
      @path = sessions_path
    else
      render 'checkout_new' if params[:checkout]
      @path = store_sessions_path(current_store.slug)
    end
  end

  def create
    cart_before_login = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      if current_store
        successful_login(cart_before_login, user)
        redirect_to new_order_path(current_store.slug)
      else
        redirect_to root_path
      end
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
