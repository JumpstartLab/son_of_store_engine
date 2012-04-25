module AuthenticationHelpers
  def require_admin
    if current_user && !current_user.admin?
      flash[:alert] = "Must be an administrator"
      redirect_to root_url
    elsif current_user.nil?
      not_authenticated
    end
  end

  def require_not_logged_in
    if current_user
      redirect_to root_url, :notice => 'Must not be logged in'
    end
  end

  def not_authenticated(msg= "You must login first")
    flash[:alert] = msg
    redirect_to '/login'
  end

  def require_guest_login
    unless @cart.guest? || current_user
      msg = "You must login first or"
      flash[:link] = ["Continue as Guest", guest_cart_path, :post]
      not_authenticated(msg)
    end
  end
end