class OrdersController < ApplicationController
  def index
    @orders = Order.all
    if params[:filter]
      @orders = Order.where(:status => params[:filter])
    end
    @filters = Order.select(:status).uniq
    @statuses = Order.count(:all, :group => :status)
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
  end

  def create
    @order = Order.create_from_cart(@cart)
    @cart.clear
    redirect_to order_path(@order)
  end

  def one_click
    one_click_cart = Cart.new(:user_id => current_user.id)
    one_click_cart.products << Product.find_by_id(params[:product])
    @order = Order.create_from_cart(one_click_cart)
    redirect_to order_path(@order)
  end
end
