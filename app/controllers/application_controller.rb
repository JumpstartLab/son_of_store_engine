class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :lookup_cart

  private

  def lookup_cart
    #session["#{current_store.slug}_cart_id"] = nil
    return nil unless current_store
    if current_user
      @cart = find_or_create_user_store_cart
    else
      @cart = find_or_create_session_store_cart
    end
    @cart.update_attribute(:user_id, current_user.id) if current_user
    session["#{current_store.slug}_cart_id"] = @cart.id
  end

  def find_or_create_session_store_cart
    cart_id = session["#{current_store.slug}_cart_id"] || current_store.carts.create.id
    Cart.find(cart_id)
  end

  def find_or_create_user_store_cart
    session_cart_id = session["#{current_store.slug}_cart_id"]
    if session_cart_id 
      session_cart = Cart.find_by_id(session_cart_id)
    end
    session["#{current_store.slug}_cart_id"]
    user_cart = current_user.store_cart(current_store) || current_user.carts.create(store_id: current_store.id)
    user_cart.absorb(session_cart) if session_cart && session_cart != user_cart
    user_cart
  end

  def authorize
    if current_user.nil?
      session[:request_page] = request.path
      redirect_to new_session_path, alert: "You need to log in first."
    end
  end

  def admin_required
    unless admin?
      redirect_to root_url,
      alert: "Not an admin and totally not cool."
    end
  end

  def user_may_stock
    unless current_user && current_user.may_stock?(current_store)
       redirect_to store_path(current_store),
      alert: "You do not have management privileges for #{current_store.name}."
    end
  end

  def user_may_manage
    unless current_user && current_user.may_manage?(current_store)
      redirect_to store_path(current_store),
      alert: "You do not have management privileges for #{current_store.name}."
    end
  end

  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id] rescue nil
  end

  def admin?
    current_user && current_user.admin
  end

  def checking_out?
    session[:checking_out] || false
  end

  def current_store
    if params[:store_id]
      Store.find_by_slug(params[:store_id])
    else
      nil
    end
  end
  
  def store_required
    unless current_store
      redirect_to root_path, notice: "Could not find the store you were looking for. Try one of these!"
    end
  end
  
  helper_method :current_store
  helper_method :lookup_cart
  helper_method :admin_authorize
  helper_method :current_user
  helper_method :admin?
  helper_method :checking_out?
end


