class StorePermissionsController < ApplicationController
  def create
    user = User.where(:email_address => params[:email]).first
    store = Store.find(params[:store_permission][:store_id])
    if user.nil?
      invite_user_to_be_admin_of(store, params[:email])
      @notice = "#{params[:email]} has been invited to join DOSE as an administrator."
    else
      StorePermission.create(user_id: user.id, store_id: store.id, permission_level: 1)
      @notice = "#{user.full_name} has been added as an administrator."
    end
    redirect_to "/#{store.domain}/admin", notice: @notice
  end
end
