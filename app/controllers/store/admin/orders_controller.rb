#
class Admin::OrdersController < ApplicationController
  before_filter :require_admin
  before_filter :lookup_order, :only => [:show, :edit, :destroy, :update]

  def index
    if params[:status] == "all"
      @orders = Order.all
    elsif params[:status]
      @orders = Order.where(:status => params[:status])
    else
      @orders = Order.all
    end
  end

  def show
  end

  def destroy
    session[:return_to] = request.url
    cancel_order
    notice = "Order Cancelled"
    redirect_to session[:return_to], notice: notice
  end

  def edit
  end

  def update
    if @order.transition
      transition_status
    else
      notice = "Please input valid billing and shipping information."
      redirect_to admin_order_path(@order), notice: notice
    end
  end

  private

  def lookup_order
    @order = Order.find(params[:id])
  end

  def cancel_order
    @order.update_attribute(:status, "cancelled")
    @order.set_action_time("cancelled")
    session[:order_id] = nil if @order.user == current_user
  end

  def transition_status
    session[:return_to] = request.url
    notice = "Transition successful"
    redirect_to session[:return_to], notice: notice
  end

end
