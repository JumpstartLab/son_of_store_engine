# Allows creating and modifying users
class UsersController < ApplicationController
  before_filter :require_admin, :only => [:index,:destroy]
  before_filter :require_not_logged_in, :only => [:new, :create]
  before_filter :require_login, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      Notification.sign_up_confirmation(@user.email).deliver
      auto_login(@user)
      redirect_back_or_to root_url, :notice => "Account successfully made!"
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

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => "Update successful"
    else
      render 'edit'
    end
  end

end
