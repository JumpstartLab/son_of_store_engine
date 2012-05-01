class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :find_or_create_cart
  before_filter :get_last_page
  after_filter :set_last_page

  helper_method :current_cart, :store, :successful_login,
        :is_store_approved

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

  def is_store_admin
    redirect_to_last_page unless 
      current_user.admin || store.admins.include?(current_user)
  end

  # def is_stocker_or_admin
  #   redirect_to_last_page("NOT ADMIN OF THIS STORE") unless
  #     store.store_admins.include?(current_user) || current_user.admin
  # end

private

  def not_found
    render "public/404.html", status: '404'
  end

  def down_for_maintenance
    render "public/maintenance", status: '404'
  end

  def is_store_approved?
    not_found if store.pending? || store.declined # store.enabled?
    down_for_maintenance if store.approved && store.disabled
  end

  def store
    @store ||= Store.find_by_url_name(request.subdomain)
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
    unless request.url == signin_url || request.url == signup_url
      session[:last_page] = request.url
    end
  end

  def successful_login(cart, user)
    cart.assign_cart_to_user(user)
    if session[:return_to_url]
      redirect_to session[:return_to_url]
      return
    elsif session[:last_page]
      redirect_to session[:last_page]
      return
    else
      redirect_to stores_path,
        :notice => "Logged in! Buy things! Capitalism!"
    end
  end

  def successful_first_login(cart, user)
    cart.assign_cart_to_user(user)
    if session[:return_to_url]
      redirect_to session[:return_to_url]
      flash[:message] = "Sign-up complete! You're now logged in! <a href=\"#{url_for(user)}\" id=\"btn\">My Profile</a>".html_safe
      return
    elsif session[:last_page]
      redirect_to session[:last_page]
      flash[:message] = "Sign-up complete! You're now logged in! <a href=\"#{url_for(user)}\" id=\"btn\">My Profile</a>".html_safe
      return
    else
      redirect_to stores_path,
        :notice => "Logged in! Buy things! Capitalism!"
    end
  end

end
