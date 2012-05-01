class OrdersController < ApplicationController
  include ExtraOrderMethods
  before_filter :lookup_order, :only => [:show, :edit, :update]
  before_filter :require_order_user, only: [:show]

  def index
    if params[:status] == "all"
      @orders = user_store_orders.page(params[:page]).per(10)
    elsif params[:status]
      @orders = user_store_orders.where(:status => params[:status]).page(params[:page]).per(10)
    else
      @orders = user_store_orders.page(params[:page]).per(10)
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
