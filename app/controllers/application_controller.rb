class ApplicationController < ActionController::Base
  protect_from_forgery
  def not_authenticated
    flash[:message] = "Please login to view this content."
    redirect_to login_url
end
end
