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
  end

  def update
    store = Store.find_by_domain(params[:id])
    store.update_attributes(params[:store])
    notify_about_status_change(store)
  end

  private

  def notify_about_status_change(store)
    if params[:store][:approval_status]
      notify_about_approval_status(store)
    elsif params[:store][:enabled]
      notify_about_enabled_status(store)
    else
      flash[:notice] = "Store has been updated successfully"
      redirect_to admin_store_path(store)
    end
  end

  def notify_about_approval_status(store)
    store.email_approval if store.approval_status == "approved"
    store.email_decline  if store.approval_status == "declined"
    flash[:notice] = "#{store.name} has been #{store.approval_status}."
    redirect_to admin_stores_path
  end

  def notify_about_enabled_status(store)
    if store.enabled
      flash[:notice] = "#{store.name} has been enabled."
    else
      store.email_decline
      flash[:notice] = "#{store.name} has been disabled."
    end
    redirect_to admin_stores_path
  end
end
