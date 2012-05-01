# You should have a very good reason to add code to this file
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :create_cart, :find_store

  rescue_from CanCan::AccessDenied do |exception|
    if @store
      url = products_path(@store)
    else
      url = root_url
    end

    redirect_to url, :alert => exception.message
  end

  include SessionsHelper
  include StoresHelper

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def down_for_maintenance
    render "#{Rails.root}/public/maintenance", :layout => false
  end

end
