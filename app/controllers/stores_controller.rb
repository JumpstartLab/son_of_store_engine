class StoresController < ApplicationController
  skip_before_filter :verify_store_status
  before_filter :verify_site_admin, :only => :index
  
  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])

    if @store.save
      @store.users << current_user
      if current_user.site_admin == true
        redirect_to store_path(@store.slug), :notice => "Creation."
      else
        store_admin = @store.users.first
        store_admin.update_attribute(:admin, true)
        redirect_to root_path, :notice => "#{@store.name} at www.store-engine.com/#{@store.slug} is waiting approval."
        StoreMailer.store_creation_alert(@store).deliver
      end
    else
      render :new
    end
  end

  def index
    @stores = Store.approved
  end
end
