# to enable the creation of new stores
class StoresController < ApplicationController
  skip_before_filter :verify_store_status

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      current_user.roles.create(name: "store_admin", store: @store)
      redirect_to "/stores/#{@store.id}", :notice => "#{@store.name} at
         www.store-engine.com/#{@store.slug} is waiting approval."
      Resque.enqueue(StoreEmailer, "store_creation_alert", @store.id)
    else
      render :new
    end
  end

  def index
    @stores = Store.all
  end

end
