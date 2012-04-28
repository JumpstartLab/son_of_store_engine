class VisitorOrdersController < ApplicationController
  before_filter :valid_email_or_redirect, :only => :new

  def create
    visitor = VisitorUser.create(:email => session[:guest_email])
    @order = visitor.orders.new(params[:order])
    @order.update_attribute(:store, current_store)
    @order.save
    @order.add_order_items_from(@cart)
    if @order.save_with_payment
      session[:cart_id] = Cart.create.id
      redirect_to store_visitor_order_path(current_store, @order.unique_url), 
                  :notice => "Transaction Complete"
    else
      render :new
    end
  end

  def new
    email = params[:guest_email]
    session[:guest_email] = email
    visitor_user = VisitorUser.new(:email => email)

    if visitor_user.save
      @path = store_visitor_orders_path(current_store)
      if @cart.quantity == 0
        redirect_to current_store,
          :alert => "You can't order something with nothing in your cart."
      else
        @order = Order.new
        @order.build_address
      end
    else 
      redirect_to new_store_checkout_path(current_store), 
        :alert => "You need a email to checkout as a Guest."
    end
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
