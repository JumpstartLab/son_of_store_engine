#
class OrdersController < ApplicationController
  before_filter :lookup_order, :only => [:show, :edit, :update]
  before_filter :require_order_user, only: [:show, :lookup]

  def index
    if params[:status] == "all"
      @orders = store_orders.all
    elsif params[:status]
      @orders = store_orders.where(:status => params[:status])
    else
      @orders = store_orders.all
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

  def lookup
    order = Order.find_by_special_url(params[:sid])
    redirect_to order_path(@current_store, order)
  end

  private

  def lookup_order
    @order = store_orders.where(id: params[:id]).first
  end

  def check_out
    link = "<a href=\"#{url_for(@order.to_s)}\">View Details</a>"
    notice = "Thank you for purchasing an email confirmation is on the way. #{link}".html_safe
    OrderMailer.order_confirmation_email(@order).deliver
    session[:previous_order_id] = session[:order_id] if !logged_in?
    session[:order_id] = nil
    redirect_to products_path(@store), notice: notice
  end

  def store_orders
    Order.where(store_id: @current_store.id)
  end

end
