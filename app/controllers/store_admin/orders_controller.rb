class StoreAdmin::OrdersController < ApplicationController
  include ExtraOrderMethods
  before_filter :lookup_order, :only => [:show, :edit, :destroy, :update]
  before_filter :confirm_has_store_admin_access

  def index
    if params[:status] == "all"
      @orders = store_orders.page(params[:page]).per(10)
    elsif params[:status]
      @orders = Order.where(:status => params[:status]).page(params[:page]).per(10)
    else
      @orders = store_orders.page(params[:page]).per(10)
    end
  end

  def show
  end

  def destroy
    session[:return_to] = request.url
    cancel_order
    notice = "Order Cancelled"
    redirect_to session[:return_to], notice: notice
  end

  def edit
  end

  def update
    if @order.transition
      transition_status
    else
      notice = "Please input valid billing and shipping information."
      redirect_to admin_order_path(@order), notice: notice
    end
  end

end
