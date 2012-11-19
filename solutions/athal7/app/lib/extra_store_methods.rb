module ExtraStoreMethods

  def notify_about_status_change(store)
    if params[:store][:approval_status]
      notify_about_approval_status(store)
    elsif params[:store][:enabled]
      notify_about_enabled_status(store)
    else
      flash[:notice] = "Store has been updated successfully"
      redirect_to admin_store_path(store)
    end
  end

  def notify_about_approval_status(store)
    store.email_approval if store.approval_status == "approved"
    store.email_decline  if store.approval_status == "declined"
    flash[:notice] = "#{store.name} has been #{store.approval_status}."
    redirect_to admin_store_path
  end

  def notify_about_enabled_status(store)
    if store.enabled
      flash[:notice] = "#{store.name} has been enabled."
    else
      store.email_decline
      flash[:notice] = "#{store.name} has been disabled."
    end
    redirect_to admin_store_path(store)
  end

  def confirm_has_store_admin_access
    unless current_user && current_user.is_admin_of(@current_store)
      redirect_to root_path
    end
  end
end
