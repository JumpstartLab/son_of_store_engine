# the Controller for all the Controllers
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_back_or_to store_path(current_store.slug)
  end

  before_filter :verify_store_status

  helper_method :current_cart
  helper_method :current_store
  helper_method :verify_store_status
  helper_method :return_path

  def current_store
    @current_store ||= Store.where(slug: params[:store_slug]).first
  end

  def current_cart
    if current_store
      @cart ||= get_cart_from_session ||
        get_cart_from_user_if_logged_in || create_new_cart
    end
  end

  def current_carts
    cart_ids = cart_storage.values
    cart_ids.map do |id|
      Cart.where(id: id).first
    end.compact
  end

  def cart_storage
    @cart_storage ||= CartStorage.new(session)
  end

  private

  def get_cart_from_session
    cart_id = cart_storage[current_store.id]
    current_store.carts.where(id: cart_id).first
  end

  def get_cart_from_user_if_logged_in
    if current_user
      cart = current_user.get_cart_for_store(current_store)
      cart_storage[current_store.id] = cart.id
      cart
    end
  end

  def create_new_cart
    cart = current_store.carts.create
    cart_storage[current_store.id] = cart.id
    cart
  end

  def verify_store_status
    if current_store && current_store.status == "pending"
      redirect_to root_path, :notice => "That store is pending approval."
    elsif current_store && current_store.status == "disabled"
      redirect_to root_path, :notice =>
        "This site is currently down for maintenence."
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to unauthorized_path, :alert => exception.message
  end

  def return_path
    if params[:return_path].blank?
      @return_path = request.referer || root_url
    else
      @return_path = params[:return_path]
    end
  end

end
