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

end
