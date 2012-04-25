class UniqueOrdersController < ApplicationController

  def show
    @order = Order.where(:unique_url => params[:id]).first
    @address = @order.address
  end
end
