module ExtraUserMethods
  def lookup_user
    @user = User.find(params[:id])
  end

  def notify_user_about_sign_up
    @user.send_welcome_email
    session[:user_id] = @user.id
    notice = "Welcome Aboard. <a href='/profile'>View Profile</a>".html_safe
    if session[:return_to]
      redirect_to session[:return_to], notice: notice
    else
      redirect_to root_path, notice: notice
    end
  end

  def update_store_permission(hex, user)
    StorePermission.find_by_admin_hex(hex).update_attributes(user_id: user.id)
  end


end
