class Admin::StoresController < ApplicationController
  include ExtraStoreMethods
  before_filter :find_store, only: [:show, :edit]
  before_filter :confirm_has_store_admin_access, only: [:show, :edit]
  before_filter :require_admin, only: [:index]

  def show
    adm_query = "store_id = ? AND permission_level = ? AND user_id IS NOT NULL"
    @admin_records = StorePermission.where(adm_query, @current_store.id, 1)
    stck_query = "store_id = ? AND permission_level = ? AND user_id IS NOT NULL"
    @stocker_records = StorePermission.where(stck_query, @current_store.id, 2)
    @store_permission = StorePermission.new
  end

  def index
    @stores = Store.all
  end

  def edit

  end

end
