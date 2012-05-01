# Allows authentication
class SessionsController < ApplicationController
  before_filter :require_not_logged_in, :only => [:create, :new]

  def new
    @user = User.new
  end

  def create
    cart_id = session["cart_#{request.subdomain}"]
    user = login(params[:user][:email], params[:user][:password],
            remember_me = false)
    if user.nil?
      @user = User.new(params[:user])
      flash[:error] = "You have entered an incorrect username or password"
      render 'new'
    else
      session["cart_#{request.subdomain}"] = cart_id
      redirect_back_or_to(root_path, :notice => 'Login successful.')
    end
  end

  def destroy
    logout
    redirect_to root_path, :notice => "You have successfully logged out"
  end
end
