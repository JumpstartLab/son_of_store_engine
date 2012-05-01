module Stores
  module Admin
    class DashboardController < BaseController
      def show
        @store = current_store
        @orders = current_store.orders.find_by_status(params[:order_status])
        @categories = current_store.categories
        authorize! :read, @store
      end
    end
  end
end