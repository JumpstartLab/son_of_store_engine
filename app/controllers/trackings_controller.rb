# Handles incoming static links for orders
class TrackingsController < ApplicationController
  def show
    @order = Order.find_by_slug params[:slug]
    @store = @order.store
    render "orders/show"
  end
end
