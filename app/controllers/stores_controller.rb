class StoresController < ApplicationController
  skip_before_filter :verify_store_status
  before_filter :verify_site_admin, :only => :index
  
  def new
    @store = Store.new
  end

  def create
    @store = Store.create(params[:store])
    if @store.save 
      if current_user.admin == true
        redirect_to store_path(@store), :notice => "Creation."
      else
        redirect_to stores_path, :notice => "Store waiting approval."
      end
    else
      render :new
    end
  end

  def index
    @stores = Store.approved
  end
end
