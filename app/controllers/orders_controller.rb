class OrdersController < ApplicationController

  before_filter :authorize
  before_filter :admin_authorize, only: [:edit, :update]

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
      @order_cart = @cart
      @order.build_address
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update_attribute(:status, params[:order][:status])
    UserMailer.status_confirmation(@order.user, @order).deliver
    redirect_to order_path(@order)
  end

  def create
    @order = Order.new(params[:order])
    @order.user_id = current_user.id
    @order.save
    @order.add_order_items_from(@cart)
    @order.address.user = current_user
    
    if @order.save_with_payment
      UserMailer.order_confirmation(current_user, @order).deliver
      @order.is_paid!
      @cart.destroy
      session[:cart_id] = nil
      redirect_to @order,
      :notice => "Transaction Complete"
    else
      render :new
    end
  end

end
