class StoresController < ApplicationController
  def index
    @stores = Store.all
  end

  def new
    @new_store = Store.new
    #raise store
  end

  def show
    redirect_to products_path(store)
  end

  def create

    @new_store = Store.create(params[:store])

    if @new_store.save
      redirect_to store_path(@new_store)
    else
      @new_store.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'new'
    end
  end

end
