module Admin
  class Controller < ApplicationController
    protect_from_forgery
    before_filter :require_login
    before_filter :find_cart, :verify_user, :require_store_admin

    include AuthenticationHelpers
    include CartHelpers
  end
end