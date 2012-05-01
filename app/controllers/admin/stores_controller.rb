class Admin::StoresController < ApplicationController
  before_filter :find_store, only: [:show, :edit]
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

  def confirm_has_store_admin_access
    unless current_user && current_user.is_admin_of(@current_store)
      redirect_to root_path
    end
  end
end
