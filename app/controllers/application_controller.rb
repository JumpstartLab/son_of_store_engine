# You should have a very good reason to add code to this file
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :create_cart, :find_store

  def create_cart
    unless session[:cart_id]
      session[:cart_id] = Cart.create.id
    end
  end

  def find_store
    if not params[:store_unique_id].blank?
      @store = Store.find_by_store_unique_id(params[:store_unique_id])
                    .where(:status => 'active').first
      not_found if not @store
    end

    if @store
      session[:return_to_store] = request.fullpath
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      session[:return_to_store] || root_url
    end
  end

  def after_sign_out_path_for(resource)
    session[:return_to_store] || root_url if resource == :user
  end

end
