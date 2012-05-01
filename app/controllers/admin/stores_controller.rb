class Admin::StoresController < ApplicationController
  include ExtraStoreMethods
  before_filter :find_store, only: [:show, :edit]
  before_filter :confirm_has_store_admin_access, only: [:show, :edit]

  def show
    @admin_records = StorePermission.where("store_id = ? AND permission_level = ? AND user_id IS NOT NULL", @current_store.id, 1)
    @stocker_records = StorePermission.where("store_id = ? AND permission_level = ? AND user_id IS NOT NULL", @current_store.id, 2)
    @store_permission = StorePermission.new
  end

  def index
    @stores = Store.all
  end

  def edit

  end

end
