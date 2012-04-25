class VisitorOrdersController < ApplicationController
  before_filter :valid_email_or_redirect, :only => :new

  def create
    visitor = VisitorUser.create(:email => session[:guest_email])
    @order = visitor.orders.create(params[:order])
    @order.add_order_items_from(@cart)
    if @order.save_with_payment
      session[:cart_id] = Cart.create.id
      redirect_to visitor_order_path(@order.unique_url), :notice => "Transaction Complete"
    else
      render :new
    end
  end

  def new
    session[:guest_email] = params[:guest_email]
    if @cart.quantity == 0
      redirect_to '/',
      :alert => "You can't order something with nothing in your cart."
    else
      @order = Order.new
      @order.build_address
    end
    @path = visitor_orders_path
  end

  def show
    @order = Order.where(:unique_url => params[:id]).first
    @address = @order.address
  end

private

  def valid_email_or_redirect
    unless User.where(:email => params[:guest_email]).count == 0 &&
           VisitorUser.where(:email => params[:guest_email]).count == 0
      redirect_to new_session_path, :alert => "Not a unique email"
    end
  end
end
