class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      flash[:message] = "Logged in!"
      redirect_back_or_to root_url
    else
      flash.now.alert = "Email or Password invalid"
    end
  end

  def destroy
    logout
    flash[:message] = "Logged out!"
    redirect_to root_url
  end
end
