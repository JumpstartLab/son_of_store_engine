class SessionsController < ApplicationController
  def new
  end

  def create
    old_cart_id = session[:cart_id]
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      @cart.absorb Cart.find_by_id(old_cart_id)
      flash[:message] = "Logged in!"
      redirect_back_or_to root_url
    else
      flash.now.alert = "Email or Password invalid"
    end
  end

  def destroy
    logout
    session[:cart_id] = nil
    flash[:message] = "Logged out!"
    redirect_to root_url
  end
end
