# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # for controlling orders
    class OrdersController < BaseController
      before_filter :authorize_store_admin!

      def index
        @orders = current_store.orders
      end

      def show
        @order = current_store.orders.find(params[:id])
      end

      def update
        @order = current_store.orders.find_by_id(params[:id])
        authorize! :update, @order
      end
    end
  end
end