#
class OrdersController < ApplicationController
  before_filter :lookup_order, :only => [:show, :edit, :update]
  before_filter :require_order_user, only: [:show]

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
    @order = store_orders.where(special_url: params[:sid]).first
    render "show"
  end

  private

  def lookup_order
    if params[:id]
      @order = store_orders.where(id: params[:id]).first
    end

  end

  def check_out
    notice = "Thank you for purchasing an email confirmation is on the way."
    @order.confirmation_email
    reset_session
    sid = @order.special_url
    redirect_to orders_lookup_path(@store, sid: sid), notice: notice
  end

  def reset_session
    session[:previous_order_id] = session[:order_id] if !logged_in?
    session[:order_id] = nil
  end

  def store_orders
    Order.where(store_id: @current_store.id)
  end

end
