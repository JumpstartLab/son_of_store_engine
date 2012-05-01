class OrdersController < ApplicationController
  before_filter :authorize
  before_filter :user_may_manage, only: [:edit, :update]

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

  def new
    if @cart.quantity == 0
      redirect_to '/',
      :alert => "You can't order something with nothing in your cart."
    else
      @order = Order.new
      @order.build_address
    end

    @path = store_orders_path(current_store)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update_status(params[:order][:status])
    redirect_to store_dashboard_path(current_store), :notice => "Order Updated"
  end

  def create
    @order = current_user.orders.new(params[:order])
    @order.update_attribute(:store, current_store)
    @order.save
    @order.add_order_items_from(@cart)
    if @order.save_with_payment
      @cart.destroy
      session[:cart_id] = Cart.create.id
      session[:checking_out] = nil
      redirect_to [current_store, @order], :notice => "Transaction Complete"
    else
      render :new
    end
  end
end
