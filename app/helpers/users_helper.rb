module UsersHelper

  def logged_in?
    session[:user_id]
  end

  def current_user
    return User.find(session[:user_id]) if logged_in?
  end

  def admin?
    if current_user.present?
      current_user.admin
    else
      false
    end
  end

  def admin_view?
    controller_path.split("/").first=="admin"
  end

  def prevent_guest
    if !logged_in?
      redirect_to login_page_path, notice: "Please sign up first"
    end
  end

  def require_user
    if current_user.nil? || current_user != @user
      redirect_to root_url, notice: "Sorry, you are not allowed to view that."
    end
  end

  def require_admin
    unless admin?
      redirect_to root_url, :notice => "Unauthorized Access"
    end
  end

end
