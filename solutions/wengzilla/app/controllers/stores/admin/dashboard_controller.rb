# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # for controlling the dashboard
    class DashboardController < BaseController
      before_filter :authorize_store_admin!

      def show
        @store = current_store
        @orders = current_store.orders.find_by_status(
            params[:order_status]).page(params[:page]).per(15)
        @categories = current_store.categories
      end
    end
  end
end