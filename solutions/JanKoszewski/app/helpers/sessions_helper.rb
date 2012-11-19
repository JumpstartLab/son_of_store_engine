module SessionsHelper
  def after_sign_in_path_for(resource)
    if resource.is_a? User
      session[:return_to_store] || root_url
    end
  end

  def after_sign_out_path_for(resource)
    session[:return_to_store] || root_url if resource == :user
  end

  def after_sign_in_path_for(user)
    user.send_welcome_email()
    session[:return_to_store] || root_url
  end
end
