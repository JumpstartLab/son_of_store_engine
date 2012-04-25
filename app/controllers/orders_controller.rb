#
class OrdersController < ApplicationController
  before_filter :lookup_order, :only => [:show, :edit, :update]
  before_filter :require_order_user, only: [:show]

  def index
    if params[:status] == "all"
      @orders = store_orders
    elsif params[:status]
      @orders = store_orders.where(:status => params[:status])
    else
      @orders = store_orders
    end
  end

  def show
  end

  def edit
  end

  def update
    if @order.status == "pending" && @order.transition
      check_out
    else
      notice = "Please input valid billing and shipping information."
      redirect_to order_path(@order), notice: notice
    end
  end

  private

  def lookup_order
    @order = store_orders.find(params[:id])
  end

  def check_out
    link = "<a href=\"#{url_for(@order.to_s)}\">View Details</a>"
    notice = "Thank you for purchasing. #{link}".html_safe
    session[:previous_order_id] = session[:order_id] if !logged_in?
    session[:order_id] = nil
    redirect_to products_path(@store), notice: notice
  end
  
  def store_orders
    Order.find_all_by_store_id(@current_store.id)
  end

end
