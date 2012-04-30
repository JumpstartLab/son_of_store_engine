# Allows authentication
class SessionsController < ApplicationController
  before_filter :require_not_logged_in, :only => [:create, :new]

  def new
    if request.subdomain.present?
      redirect_to(request.protocol + request.domain + (request.port.nil? ? '' : ":#{request.port}") + "/login")
    end
    @user = User.new
  end

  def create
    cart_id = session["cart_#{request.subdomain}"]
    current_store = session[:current_store] 
    user = login(params[:user][:email], 
           params[:user][:password],
          remember_me = false)
    if user.nil?
      @user = User.new(params[:user])
      flash[:error] = "You have entered an incorrect username or password"
      render 'new'
    else
      session["cart_#{request.subdomain}"] = cart_id
      redirect_back_or_to(subdomain_path(current_store), :notice => 'Login successful.')
    end
  end

  def destroy
    logout
    redirect_to root_path, :notice => "You have successfully logged out"
  end
end
