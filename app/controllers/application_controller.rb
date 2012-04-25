# You should have a very good reason to add code to this file
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :create_cart

  def create_cart
    unless session[:cart_id]
      session[:cart_id] = Cart.create.id
    end
  end
end
