class SessionsController < ApplicationController

  def new
  end

  def create
    cart = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(cart, user)
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

  def successful_login(new_cart, user)
    if new_cart.has_products?
      user.cart = new_cart
    else
      new_cart.destroy
    end
    redirect_to_last_page("Logged in!")
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
