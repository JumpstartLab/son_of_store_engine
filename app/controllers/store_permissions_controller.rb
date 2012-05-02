class StorePermissionsController < ApplicationController
  include ExtraStorePermissionMethods
  before_filter :validate_added_email, only: :create
  before_filter :find_store, only: :destroy

  def create
    if added_user.nil?
      invite_user
    else
      give_user_permissions(added_user)
    end
    redirect_to admin_store_path(store), notice: notice
  end

  def destroy
    store_permission = StorePermission.find(params[:id])
    store = Store.find(store_permission.store_id)
    store_permission.destroy
    redirect_to admin_store_path(store), notice: "Employee has been terminated."
  end

  private

  def validate_added_email
    unless params[:email].match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/)
      redirect_to :back, notice: "Invalid Email"
    end
  end

  def added_user
    @added_user ||= User.where(:email_address => params[:email]).first
  end

  def store
    @store ||= Store.find(params[:store_permission][:store_id])
  end
end
