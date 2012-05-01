class Admin::StoresController < ApplicationController
  include ExtraStoreMethods
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

end
