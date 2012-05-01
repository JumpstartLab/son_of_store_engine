class SessionsController < ApplicationController
  include ExtraSessionMethods
  def new
    session[:return_to] = request.referrer
  end

  def index
    redirect_to root_url
  end

  def create
    user = User.find_by_email_address(params[:email])
    if valid_user?(user)
      start_session(user)
    else
      render :new, :notice => 'Try again'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:order_id] = nil
    redirect_to root_url, :notice => 'Thanks for Visting'
  end

end
