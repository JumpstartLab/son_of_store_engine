class OrdersController < ApplicationController
  before_filter :verify_is_admin, :only => [:index, :update, :destroy]

  def index
    @orders = Order.all
    if params[:filter]
      @orders = Order.where(:status => params[:filter])
    end
    @filters = Order.select(:status).uniq
    @statuses = Order.count(:all, :group => :status)
  end

  def edit
    @order = Order.find_by_id(params[:id])
  end

  def update
    @order = Order.find_by_id(params[:id])
    @order.update_attributes(params[:order])
    @order.save
    redirect_to orders_path
  end

  def show
    @order = Order.find_by_id(params[:id])
  end

  def new
    render :action => :create if current_user.customer
    @order = Order.new
    @customer = Customer.find_or_create_by_user(current_user)
  end

  def create
    # @order = Order.create_from_cart(@cart, Customer.new(params[:customer]))
    @order = Order.create_from_cart(@cart)
    @order.customer = Customer.create(params[:customer])
    @cart.clear
    redirect_to order_path(@order)
  end

  def one_click
    one_click_cart = Cart.create(:user_id => current_user.id)
    one_click_cart.add_product_by_id(params[:product])
    @order = Order.create_from_cart(one_click_cart)
    redirect_to order_path(@order)
  end

  def destroy
    @order = Order.find_by_id(params[:id])
    @order.destroy
    redirect_to orders_path
  end
end
