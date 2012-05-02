module ExtraStorePermissionMethods
  def give_user_permissions(added_user)
    store_permission = StorePermission.new(params[:store_permission])
    store_permission.user_id = added_user.id
    store_permission.save
    notice = "#{added_user.full_name} has been given this role."
  end

  def invite_user
    StorePermission.invite_user_to_access_store(params[:store_permission],
                                                params[:email])
    notice = "#{params[:email]} is not currently a DOSE member."+
      "They have been invited to sign up to fulfill this role."
  end
end
