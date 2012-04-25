class StoresController < ApplicationController
  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to admin_store_path(@store)
    else
      render 'new'
    end
  end

  def show
    @store = Store.find_by_id(params[:id])
    unless @store.enabled
      redirect_to root_path, notice: "Store Not Found"
    end
  end
end
