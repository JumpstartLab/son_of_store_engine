class Admin::StoresController < ApplicationController

  before_filter :find_store, only: [:approve, :decline, :enable, :disable, :edit]

  def index
    @stores = Store.all
  end

  def approve
    @store.approve!
    redirect_to admin_stores_path, notice: "Approved"
  end

  def decline
    @store.decline!
    redirect_to admin_stores_path, notice: "Declined"
  end

  def enable
    @store.enable!
    redirect_to admin_stores_path, notice: "Enabled"
  end

  def disable
    @store.disable!
    redirect_to admin_stores_path, notice: "Disabled"
  end

  def edit
  end

  def find_store
    @store = Store.find_by_slug(params[:id])
  end

end
