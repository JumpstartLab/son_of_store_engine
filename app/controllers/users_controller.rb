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
    session[:return_to] = request.referrer
  end

  def create
    @user = User.new(params[:user])
    @notice = 'Welcome Aboard'
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to session[:return_to] }
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

  def profile
    @user = current_user
    render 'show'
  end

  private

  def lookup_user
    @user = User.find(params[:id])
  end

end
