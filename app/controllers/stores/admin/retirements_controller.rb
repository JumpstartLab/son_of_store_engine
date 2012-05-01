module Stores
  module Admin
    class RetirementsController < BaseController
      def create
        product = Product.find(params[:product_id])
        authorize! :retire, product 

        if product.active?
          product.retire
        else
          product.activate
        end
        redirect_to store_admin_products_path(current_store.slug), notice: 'Product has been retired.'
      end
    end
  end
end