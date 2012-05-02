module Stores
  module Admin
    class RetirementsController < BaseController

      def create
        product = current_store.products.find(params[:product_id])
        authorize! :retire, product

        product.active? ? product.retire : product.activate
        redirect_to store_admin_products_path(current_store.slug),
          notice: 'Product status changed.'
      end

    end
  end
end