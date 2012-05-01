class Admin::StoresController < ApplicationController
  before_filter :lookup_store, only: [:show, :edit]
  before_filter :confirm_has_store_admin_access, only: [:show, :edit]

  def show
    @store_permission = StorePermission.new
  end

  def index
    @stores = Store.all
  end

  def edit

  end

  private

  def lookup_store
    if params[:domain]
      store_domain = params[:domain]
    elsif params[:id]
      store_domain = params[:id]
    end
    @store = Store.find_by_domain(store_domain)
  end

  def confirm_has_store_admin_access
    redirect_to root_path unless current_user && current_user.is_admin_of(@store)
  end
end
