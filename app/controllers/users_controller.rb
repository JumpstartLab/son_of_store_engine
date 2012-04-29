# Users are generally handled by devise, unless creating a new billing.
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    @user.update_roles(params[:user][:role_ids])
    redirect_to users_path, :notice => "#{@user.name} updated successfully."
  end
end
