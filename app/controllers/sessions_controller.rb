class SessionsController < ApplicationController
  skip_after_filter :set_last_page, :only => ["new", "create"]

  def new
  end

  def create
    last_page = session[:last_page]
    cart = current_cart
    if user = login(params[:email], params[:password], params[:remember_me])
      successful_login(cart, user)
      redirect_to last_page || root_path
    else
      session[:cart_id] = cart.id
      invalid_email
    end
  end

  def destroy
    last_page = session[:last_page]
    logout
    reset_session
    redirect_to last_page, :notice => "Logged out."
  end

  private

  def successful_login(cart, user)
    cart.assign_cart_to_user(user)
    flash[:message] = "Logged in! Buy things! Capitalism!"
  end

  def invalid_email
    flash.now.alert = "Email or password was invalid."
    render :new
  end

end
