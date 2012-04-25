# Allows restful actions for orders + charging orders
class OrdersController < ApplicationController
  before_filter :require_guest_login, :only => [:new]  
  before_filter :require_login, :except => [:track, :charge, :new]
  before_filter :is_owner_or_admin, :only => [:show]

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.find_cart(@cart.id)
  end

  def charge
    @order = @cart.create_order
    if @order.verify_user_and_charge(params[:order])
      clear_cart_from_session
      redirect_to track_orders_path(:id => @order.unique_url), 
        :notice => "I HAVE ALL YOUR MONEY!"
    else
      flash[:alert] = "Address is invalid"
      render 'new'
    end
  end

  def track
    @order = Order.find_by_unique_url(params[:id])
    if @order
      render 'show'
    else
      redirect_to root_url, :notice => 'Invalid Order tracking code' and return
    end
  end

  def my_orders
    st = params[:mq]
    if st
      orders = current_user.orders.
      joins(:products).where('products.name LIKE ? or
      products.description LIKE ?',"%#{st}%",
      "%#{st}%").uniq
    else
      orders = current_user.orders
    end

    status = Status.find_or_create_by_name("incomplete")
    @orders = orders - current_user.orders.where(:status_id => status.id)
  end

private

  def is_owner_or_admin
    @order = Order.find_by_id(params[:id])
    if not current_user.admin? and @order.user != current_user
      redirect_to root_url, :notice => 'That is not your order'
    end
  end

end
