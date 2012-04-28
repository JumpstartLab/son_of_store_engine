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
    session[:previous_page] = request.referer
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
      store = Store.find_by_id(session[:checkout_store_id])
      link = "<a href=\"#{edit_user_path(@user)}\">Edit User Settings</a>" 
      notice = "Thank you for signing up!  #{link}".html_safe 
      if checking_out? && session[:checkout_store_id]
        redirect_to new_store_order_path(store), notice: notice
      elsif session[:previous_page] == new_user_url
        redirect_to root_path, notice: notice
      else
        redirect_to session[:previous_page], notice: notice
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


