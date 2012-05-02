class SessionsController < ApplicationController

  def index
    redirect_to store_path,
      :notice => "Chef Pierre says, 'Bonjour!'"
  end

  def new
  end

  def create
    cart = current_cart
    last_page = session[:last_page]
    if user = login(params[:email], params[:password], params[:remember_me])
      session[:last_page] = last_page
      successful_login(cart, user)
    else
      reject_login(cart)
    end
  end

  def destroy
    logout
    reset_session
    redirect_to root_url(subdomain: false), :notice => "Logged out."
  end

private

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

  def reject_login(cart)
    session[:cart_id] = cart.id
    invalid_email
  end

end
