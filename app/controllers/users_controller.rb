#
class UsersController < ApplicationController
  before_filter :lookup_user,
    :only => [:show, :edit, :destroy, :update, :view_as_admin,
              :view_as_normal]
  before_filter :require_user, :only => [:edit, :update, :show]
  before_filter :prevent_guest, only: :profile

  def show
  end

  def new
    @user = User.new
    @invite_code = params[:invite_code] if params[:invite_code]
    session[:return_to] = request.referrer
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      update_store_permission(params[:invite_code], @user) if params[:invite_code]
      @user = User.find_by_email_address(@user.email_address)
      notify_user_about_sign_up
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end

  def profile
    @user = current_user
    render 'show'
  end

  private

  def lookup_user
    @user = User.find(params[:id])
  end

  def notify_user_about_sign_up
    @user.send_welcome_email
    session[:user_id] = @user.id
    redirect_to session[:return_to], notice: "Welcome Aboard. <a href='/profile'>View Your Profile</a>".html_safe
  end

  def update_store_permission(hex, user)
    raise StorePermission.last.inspect
    StorePermission.find_by_admin_hex(hex).update_attributes(user_id: user.id)
  end

end
