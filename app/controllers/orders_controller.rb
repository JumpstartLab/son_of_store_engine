class OrdersController < ApplicationController
  include ExtraOrderMethods
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

end
