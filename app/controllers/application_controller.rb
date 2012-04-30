class ApplicationController < ActionController::Base 
  protect_from_forgery

  before_filter :verify_store_status
  
  helper_method :current_cart
  helper_method :current_store
  helper_method :verify_store_status
  helper_method :url_for

  def current_store
    @current_store ||= Store.where(slug: params[:store_slug]).first
  end

  def current_cart
    if current_store
      @cart ||= get_cart_from_session || get_cart_from_user_if_logged_in || create_new_cart
    end
  end

  def current_carts
    ids = cart_storage.values
    ids.map do |id|
      Cart.where(id: id).first
    end.compact
  end

  def cart_storage
    @cart_storage ||= CartStorage.new(session)
  end

  private

  def get_cart_from_session
    cart_id = cart_storage[current_store.id]
    current_store.carts.where(:id => cart_id, :store_id => current_store.id).first
  end

  def get_cart_from_user_if_logged_in
    if current_user
      cart = current_user.carts.where(:store_id => current_store.id).first || current_user.carts.create!(:store_id => current_store.id)
      cart_storage[current_store.id] = cart.id
      cart
    end
  end

  def url_options
    { :store_slug => current_store.slug }.merge(super)
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
      redirect_to root_path, :notice => "That store has been disabled."
    end
  end
end
