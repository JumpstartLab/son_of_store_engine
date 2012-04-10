class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter { @cart = find_or_create_cart_from_session }
  before_filter { @bitly = Bitly.new('dkaufman16', 'R_93a76875d901c6d76064f30a298f2791') }

  def not_authenticated
    flash[:message] = "Please login to view this content."
    redirect_to login_url
  end

private

  def find_or_create_cart_from_session
    cart = Cart.find_by_id(session[:cart_id])
    cart ||= Cart.create(:user => current_user)
    session[:cart_id] = cart.id
    cart
  end
end