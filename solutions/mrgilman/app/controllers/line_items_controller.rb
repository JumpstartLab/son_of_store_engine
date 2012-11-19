#
class LineItemsController < ApplicationController
  before_filter :lookup_line_item, :only => [:show, :edit, :destroy, :update]
  before_filter :lookup_order, :only => [:show, :edit, :destroy, :update]

  def index
    redirect_to products_path(@store)
  end

  def create
    if !session[:order_id]
      create_order
    end
    params[:line_item][:order_id] = session[:order_id]
    LineItem.increment_or_create_line_item(params[:line_item])
    redirect_to products_path(@store)
  end

  def edit
    session[:return_to] = request.referrer
  end

  def show
    redirect_to order_path(@order)
  end

  def update
    if params[:line_item][:quantity] == "0"
      @line_item.destroy
    else
      @line_item.update_attributes(params[:line_item])
    end
    redirect_to session[:return_to]
  end

  def destroy
    @line_item.destroy
    redirect_to order_path(@order)
  end

  private

  def create_order
    order = Order.create(store_id: @current_store.id)
    if session[:user_id]
      order.add_user(session[:user_id])
      order.try_to_add_billing_and_shipping(session[:user_id])
    end
    session[:order_id] = order.id
  end

  def lookup_line_item
    @line_item = LineItem.find(params[:id])
  end

  def lookup_order
    @line_item = LineItem.find(params[:id])
    @order = Order.find(@line_item.order_id)
  end
end
