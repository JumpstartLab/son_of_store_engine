class SessionsController < ApplicationController

  def new
  end

  def create
    cart = current_cart
    last_page = session[:last_page]
    if user = login(params[:email], params[:password], params[:remember_me])
      session[:last_page] = last_page
      successful_login(cart, user)
    else
      session[:cart_id] = cart.id
      invalid_email
    end
  end

  def destroy
    logout
    reset_session
    redirect_to root_url, :notice => "Logged out."
  end

private

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
