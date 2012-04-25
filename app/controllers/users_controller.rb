class UsersController < ApplicationController

  before_filter :authorize, :only => [:edit, :update, :delete, :show, :profile]
  before_filter :edit_self, :only => [:edit, :update]

  def show
    @user = User.find_by_id(params[:id])
    @addresses = @user.addresses
  end

  def profile
    @user = current_user
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user), :notice => "User updated."
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      if checking_out?
        redirect_to new_order_path, notice: "Thank you for signing up!"
      else 
        redirect_to root_path, notice: "Thank you for signing up!"
      end 
    else
      render "new"
    end
  end

  private

  def edit_self
    if current_user && current_user.id.to_i != params[:id].to_i
      redirect_to root_url, :notice => "You can only edit yourself."
    end
  end
end


