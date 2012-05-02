# the wrapper for the store_slugs
module Stores
  # the module for store-specific admins
  module Admin
    # for updating order statuses
    class StatusesController < BaseController
      before_filter :authorize_store_admin!

      def create
      end

      def update
        @order_status =
          current_store.orders.find(params[:order_id]).order_status
        @order_status.update_status(params[:new_status])
        redirect_to store_admin_path,
          :notice => "Order status has been updated."
      end

    end
  end
end