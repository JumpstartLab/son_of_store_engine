class SessionsController < ApplicationController
  def new
    session[:return_to] = request.referrer
  end

  def create
    @old_cart_id = @cart.id
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      create_with_user(user)
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

  def find_and_absorb
    find_or_create_cart_from_session.absorb(
      Cart.find_by_id(@old_cart_id))
    @cart
  end

  def flash_and_user_cart
    session[:old_cart_id] = @old_cart_id
    flash[:message] = "Logged in!"
    Cart.find_by_user_id(current_user.id)
  end

  def create_with_user(user)
    user_cart = flash_and_user_cart
    session[:cart_id] = user_cart ? user_cart.id : nil
    @cart = find_and_absorb
    @cart.user_id = current_user.id
    save_and_redirect
  end

  def save_and_redirect
    @cart.save
    redirect_to root_path
  end
end
