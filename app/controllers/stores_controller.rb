class StoresController < ApplicationController
  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to store_path(@store)
    else
      render 'new'
    end
  end

  def show
    raise params.inspect
    @store = Store.find_by_id(params[:id])
  end
end
