class ShippingDetailsController < ApplicationController

  def new
    @shipping_detail = ShippingDetail.new
  end

  def create
    if current_user.shipping_details.create(params[:shipping_detail])
      redirect_to new_order_path
    else
      render 'new'
    end
  end

end
