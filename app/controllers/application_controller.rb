#
class ApplicationController < ActionController::Base
  include UsersHelper
  include OrdersHelper
  include BillingMethodsHelper
  include ShippingAddressesHelper

  before_filter :find_store

  def find_store
    if params[:domain]
      store_domain = params[:domain]
    elsif params[:id]
      store_domain = params[:id]
    end
    @current_store = Store.find_by_domain(store_domain)
  end

  protected
end
