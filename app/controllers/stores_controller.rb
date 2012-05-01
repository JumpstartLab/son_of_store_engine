class StoresController < ApplicationController
  include ExtraStoreMethods
  before_filter :find_store, only: [:show]

  def index
    @stores = Store.where(:enabled => true)
  end


  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    @store.creating_user_id = current_user.id
    if @store.save
      redirect_to admin_store_path(@store)
    else
      render 'new'
    end
  end

  def show
  end

  def update
    store = Store.find_by_domain(params[:id])
    store.update_attributes(params[:store])
    notify_about_status_change(store)
  end

end
