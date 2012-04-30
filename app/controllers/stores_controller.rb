# Displays all the active / pending stores as well as allow creation of new
# stores
class StoresController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def show
    redirect_to products_path(@store)
  end

  def index
    session[:return_to_store] = root_url

    if current_user
      @pending_stores = current_user.stores.pending
      @stores = current_user.stores.active
    end
  end

  def new
    @store_new = Store.new
  end

  def create
    @store_new = Store.new(params[:store])
    @store_new.add_admin(current_user)
    if @store_new.save
      redirect_to root_url,
        :notice => 'Your store needs to be approved before accessing.'
    else
      render 'new'
    end
  end
end
