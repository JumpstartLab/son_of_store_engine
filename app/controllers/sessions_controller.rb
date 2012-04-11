class SessionsController < ApplicationController
  def new
  end

  def create
    @old_cart_id = @cart.id
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      session[:old_cart_id] = @old_cart_id
      user_cart = Cart.find_by_user_id(current_user.id)
      session[:cart_id] = user_cart ? user_cart.id : nil
      @cart = find_or_create_cart_from_session
      @cart.absorb(Cart.find_by_id(@old_cart_id))
      flash[:message] = "Logged in!"
      @cart.user_id = current_user.id
      @cart.save!
      redirect_back_or_to root_url
    else
      flash[:message] = "Email or Password invalid"
      render :action => "new"
    end
  end

  def destroy
    @cart.save!
    logout
    session[:cart_id] = nil
    flash[:message] = "Logged out!"
    redirect_to root_url
  end
end
