class SessionsController < ApplicationController
  def create
    user = lookup_by_email_or_username(params[:account_name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      new_session
    else
      flash.now.alert = "Email or password is invalid."      
      render "new"
    end
  end

  def new_session
    if session[:request_page].blank? && checking_out?
      redirect_to new_order_path, notice: "Logged in!"
    elsif session[:request_page].blank?
      redirect_to root_url, notice: "Logged in!"
    else
      new_session = session[:request_page]
      session[:request_page] = nil
      redirect_to new_session, notice: "Logged in!"
    end
  end

  def destroy
    session.clear
    respond_to do |format|
      format.html { redirect_to root_url, notice: "Logged out!" }
    end
  end

  private

  def lookup_by_email_or_username(account_name)
    user = User.find_by_email(account_name)
    if user.nil?
      user = User.find_by_username(account_name)
    end
    user
  end
end
