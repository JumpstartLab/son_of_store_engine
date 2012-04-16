class SearchesController < ApplicationController
  def show
    if params[:search][:products]
      @products = Product.search(params[:search][:products])
    elsif params[:search][:orders]
      @orders = Order.search(params[:search][:orders], current_user)
    end
    @search = Search.new
  end
end
