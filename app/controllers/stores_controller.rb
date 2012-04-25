class StoresController < ApplicationController
  layout false, :only => [:index, :new, :create]
  
  def new
    @store = Store.new
  end

  def create
    @store = Store.create(params[:store])
    if @store.save
      redirect_to stores_path, :notice => "Store waiting approval."
    else
      render :new
    end
  end

  def index
    @stores = Store.approved
    # @stores = Store.all
    render :layout => false
  end
end
