class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter { @cart = find_or_create_cart_from_session }
  before_filter { @new_search = Search.new }

  def not_authenticated
    flash[:message] = "Please login to view this content."
    redirect_to login_url
  end
  
  def code
    redirect_to URI.encode("https://github.com/tyre/store_engine")
  end

private


  def find_or_create_cart_from_session
    cart = Cart.find_by_id(session[:cart_id])
    cart ||= Cart.create(:user => current_user)
    if session[:old_cart_id]
      cart.absorb(Cart.find_by_id(session[:old_cart_id]))
      session[:old_cart_id] = nil
    end
    session[:cart_id] = cart.id
    cart
  end

  def verify_is_admin
    # unless current_user && !current_user.is_admin?
    #   redirect_to root_path
    # end
  end
end