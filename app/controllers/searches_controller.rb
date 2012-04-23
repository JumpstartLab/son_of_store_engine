class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    if params[:search][:products]
      @products = Product.search(params[:search][:products])
    elsif params[:search][:orders]
      @orders = Order.search(params[:search][:orders], current_user)
    end
    @search = Search.new
  end

  def admin_show
    @orders = Search.new.find params[:search]
  end
end
