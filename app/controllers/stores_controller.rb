class StoresController < ApplicationController

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
    @store = Store.find_by_id(params[:id])
    if @store.nil? || !@store.enabled
      redirect_to root_path, notice: "Store Not Found"
    end
  end

  def update
    store = Store.find_by_domain(params[:id])
    store.update_attributes(params[:store])
    if params[:store][:approval_status] && store.approval_status == "approved"
      store.email_approval
      flash[:notice] = "#{store.name} has been approved."
    elsif params[:store][:approval_status] && store.approval_status == "declined"
      store.email_decline
      flash[:notice] = "#{store.name} has been declined."
    end
    redirect_to admin_stores_path
  end
end
