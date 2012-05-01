module AuthenticationHelpers

  def require_store_admin
    unless current_user.admin? || current_tenant.editable?(current_user)
      flash[:alert] = "Must be an administrator"
      redirect_to root_url
    end
  end

  def require_admin
    unless current_user.admin?
      flash[:alert] = "Must be site administrator"
      redirect_to root_url
    end
  end

  def require_not_logged_in
    if current_user
      redirect_to root_url, :notice => 'Must not be logged in'
    end
  end

  def not_authenticated(msg= "You must login first")\
    flash[:alert] = msg
    redirect_to '/login'
  end

  def require_guest_login
    unless @cart.guest? || current_user
      msg = "You must login first or"
      flash[:link] = ["Continue as Guest", guest_cart_path, :post]
      require_login
    end
  end
end