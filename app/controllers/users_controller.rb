# Allows creating and modifying users
class UsersController < ApplicationController
  before_filter :require_admin, :only => [:index,:destroy]
  before_filter :require_not_logged_in, :only => [:new, :create]
  before_filter :require_login, :only => [:edit, :update]
  cache_sweeper :user_sweeper

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    current_store = session[:current_store]
    if @user.save
      auto_login(@user)
      redirect_back_or_to(subdomain_path(current_store), :notice => "Account successfully made! " + view_context.link_to("Update your info", profile_path))
    else
      render '/sessions/new'
    end
  end

  # Not yet needed
  # def signup_as_store_admin
  #   u = User.find_by_email(params[:email])
  # end

  # def create_store_admin
  #   u = User.find_by_email(params[:email])
  #   u.password = params[:user][:password]
  #   u.name = params[:user][:name]
  #   u.guest = false
  #   u.save
  #   redirect_to root_url notice: "Account made."
  # end

  def edit
    @user = current_user
  end

  # def show
  # end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => "Update successful"
    else
      render 'edit'
    end
  end

end
