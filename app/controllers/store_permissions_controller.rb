class StorePermissionsController < ApplicationController
  before_filter :validate_added_email, only: :create
  before_filter :find_store, only: :destroy

  def create
    added_user = User.where(:email_address => params[:email]).first
    store = Store.find(params[:store_permission][:store_id])
    if added_user.nil?
      StorePermission.invite_user_to_access_store(params[:store_permission], params[:email])
      notice = "#{params[:email]} is not currently a DOSE member. They have been invited to sign up to fulfill this role."
    else
      store_permission = StorePermission.new(params[:store_permission])
      store_permission.user_id = added_user.id
      store_permission.save
      notice = "#{added_user.full_name} has been given this role."
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
end