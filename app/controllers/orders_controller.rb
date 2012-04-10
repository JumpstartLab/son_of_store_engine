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
    order = Order.new
    @cart.cart_items.each do |cart_item|
      OrderItem.create!(product: cart_item.product, order: order)
    end
    @order = order.save!
    redirect_to order_path(@order)
  end
end
