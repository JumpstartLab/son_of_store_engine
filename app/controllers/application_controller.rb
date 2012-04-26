class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :verify_store_status
  before_filter :get_last_page
  after_filter :set_last_page

  helper_method :current_cart
  helper_method :current_store
  helper_method :verify_store_status

  def current_store
    @current_store ||= Store.where(slug: params[:store_slug]).first
  end

  def get_last_page
    @last_page = "Your last page: #{session[:last_page]}"
  end

  def current_cart
    if current_store
      @cart ||= get_cart_from_session || get_cart_from_user_if_logged_in || create_new_cart
    end
  end

  def cart_storage
    @cart_storage ||= CartStorage.new(session)
  end

  # def redirect_to_last_page(message=nil)
  #   last_page = params[:last_page] || session[:last_page]
  #   if last_page
  #     redirect_to(last_page, :notice => message)
  #   else
  #     redirect_to(root_path, :notice => message)
  #   end
  # end

  def redirect_to_login(message=nil)
    #redirect_to signin_path
  end

  def is_admin?
    #redirect_to_last_page unless current_user.admin
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

  def create_new_cart
    cart = current_store.carts.create
    cart_storage[current_store.id] = cart.id
    cart
  end

  def set_last_page
    session[:last_page] = request.url
  end

  def verify_store_status
    if current_store && current_store.status == "pending"
      redirect_to stores_path, :notice => "That store is pending approval."
    elsif current_store && current_store.status == "disabled"
      redirect_to stores_path, :notice => "That store has been disabled."
    end
  end

  def verify_site_admin
    #redirect_to store_path('mittenberry') unless current_user && current_user.site_admin == true
  end

end
