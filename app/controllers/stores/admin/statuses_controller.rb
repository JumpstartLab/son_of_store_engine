module Stores
  module Admin
    class StatusesController < BaseController
      before_filter :authorize_store_admin!

      def create
      end

      def update
        @order_status = OrderStatus.find_by_order_id(params[:order_id])
        @order_status.update_status(params[:new_status])
        redirect_to store_admin_path, :notice => "Status updated!"
      end

    end
  end
end