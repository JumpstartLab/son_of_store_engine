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

  def not_authenticated
    flash[:alert] = "You must login first"
    redirect_to '/login'
  end

end