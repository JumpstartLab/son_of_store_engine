class StoresController < ApplicationController
  skip_before_filter :verify_store_status
  before_filter :verify_site_admin, :only => :index

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      @store.users << current_user
      redirect_to "/stores/#{@store.id}", :notice => "#{@store.name} at www.store-engine.com/#{@store.slug} is waiting approval."
      StoreMailer.store_creation_alert(@store).deliver
    else
      render :new
    end
  end

  def index
    @stores = Store.approved
  end
end
