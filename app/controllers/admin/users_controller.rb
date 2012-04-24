#
class Admin::UsersController < ApplicationController
  before_filter :lookup_user,
                :only => [:show, :edit, :destroy, :update, :view_as_admin,
                          :view_as_normal]
  before_filter :require_admin

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @notice = 'Welcome Aboard'
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_url, notice: @notice }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
  end

  def update
    @user.update_attributes(params[:user])
    redirect_to user_path(@user)
  end

  def view_as_admin
    session[:return_to] = request.referrer
    if logged_in? && admin?
      @user.enable_admin_view
      redirect_to session[:return_to], notice: "Viewing as admin"
    else
      redirect_to root_url, notice: "Please sign in to see admin view"
    end
  end

  def view_as_normal
    session[:return_to] = request.referrer
    if logged_in? && admin?
      @user.disable_admin_view
      redirect_to session[:return_to], notice: "Viewing as normal user"
    else
      redirect_to root_url, notice: "Please sign in to see admin view"
    end
  end

  private

  def lookup_user
    @user = User.find(params[:id])
  end

end
