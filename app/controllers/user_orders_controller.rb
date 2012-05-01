class UserOrdersController < ApplicationController

  def index
    if params[:status_search] && current_user && current_user.admin?
      @orders = Order.where(status: params[:status_search])
    else
      @orders = Order.find_all_by_user_id(current_user.id)
    end
  end

  def show
    @order = Order.find(params[:id])
    @address = @order.address
  end

end
