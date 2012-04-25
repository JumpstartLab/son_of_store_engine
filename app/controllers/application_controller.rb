#
class ApplicationController < ActionController::Base
  include UsersHelper
  include OrdersHelper
  include BillingMethodsHelper
  include ShippingAddressesHelper
  
  before_filter :find_store_from_domain
  
  def find_store_from_domain
    @store = Store.find_by_domain(params["domain"])
  end

  protected



end
