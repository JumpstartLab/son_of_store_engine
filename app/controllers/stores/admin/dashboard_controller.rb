module Stores
  module Admin
    class DashboardController < BaseController
      before_filter :authorize_store_admin!
      
      def show
        @store = current_store
        @orders = current_store.orders.find_by_status(params[:order_status]).page(params[:page]).per(15)
        @categories = current_store.categories
      end
    end
  end
end