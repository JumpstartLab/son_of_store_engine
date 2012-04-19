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
    @order = current_user.customer.orders.find_by_id(params[:id])
  end

  def new
    self.create if current_user.customer
    @order = Order.new(customer: Customer.find_or_create_by_user(current_user))
  end

  def create
    customer = Customer.find_by_user_id(current_user) ||
    Customer.new(params[:customer])
    if customer.save  
      @order = Order.create(customer: customer, status: "paid")
      @order.add_from_cart(@cart)
      if @order.save 
        ConfirmationMailer.confirmation_email(current_user).deliver 
        @cart.clear
        redirect_to order_path(@order)
      else
        render 'orders/new'
      end
    end
  end

  def one_click
    if Customer.find_by_user_id(current_user.id)
      one_click_cart = Cart.create(:user_id => current_user.id)
      one_click_cart.add_product_by_id(params[:product])
      @order = Order.create_from_cart(one_click_cart)
      ConfirmationMailer.confirmation_email(current_user).deliver
      redirect_to order_path(@order, :id => @order.id)
    else
      flash[:message]= "We're sorry, but you must have placed a previous order to use 2-click. Please fill out your info below."
      redirect_to new_order_path
    end
  end

  def destroy
    @order = Order.find_by_id(params[:id])
    @order.destroy
    redirect_to orders_path
  end
end
