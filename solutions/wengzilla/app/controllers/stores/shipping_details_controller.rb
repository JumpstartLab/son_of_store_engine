# module for the store_slug namespage
module Stores
  # to add shipping details for orders in each store
  class ShippingDetailsController < ApplicationController

    def new
      @shipping_detail = ShippingDetail.new
    end

    def create
      if current_user.shipping_details.create(params[:shipping_detail])
        redirect_to new_store_order_path
      else
        render 'new'
      end
    end

  end
end