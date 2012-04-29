class ApplicationController < ActionController::Base
module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host] = with_subdomain(options.delete(:subdomain))
    end
    super
  end
end
  include UrlHelper
  protect_from_forgery

  before_filter :find_or_create_cart
  before_filter :get_last_page
  after_filter :set_last_page

  helper_method :current_cart, :store

  def get_last_page
    @last_page = "Your last page: #{session[:last_page]}"
  end

  def current_cart
    @cart ||= find_or_create_cart
  end

  def redirect_to_last_page(message=nil)
    last_page = params[:last_page] || session[:last_page]
    if last_page
      redirect_to(last_page, :notice => message)
    else
      redirect_to(root_path, :notice => message)
    end
  end

  def redirect_to_login(message=nil)
    redirect_to signin_path
  end

  def is_admin?
    redirect_to_last_page unless current_user.admin
  end

  def is_store_admin?
    redirect_to_last_page("Nice try, jerk.") unless
      store.admins.include?(current_user)
  end

private

  def store
    @store ||= Store.find_all_by_url_name(request.subdomain).first
  end

  def find_or_create_cart
    if session[:cart_id] && cart = Cart.find_by_id(session[:cart_id])
      cart
    elsif current_user
      get_cart_from_user
    else
      Cart.create.tap{ |cart| session[:cart_id] = cart.id; }
    end
  end

  def get_cart_from_user
    cart = current_user.cart || Cart.create!
    session[:cart_id] = cart.id
    current_user.cart = cart
  end

  def set_last_page
    session[:last_page] = request.url
  end

end
