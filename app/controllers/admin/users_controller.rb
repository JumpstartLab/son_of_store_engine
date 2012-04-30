# Admins have direct access to administering or creating new admins
class Admin::UsersController < Admin::ApplicationController
  def index
    @users = @store.users.all.sort_by { |user| user.name }
  end

  def create
    if @store.add_admin_user(params[:email])
      notice = "New admin successfully added."
    else
      @store.invite_new_user(params[:email])
      notice = "User with email '#{params[:email]}' does not exist."
    end
    redirect_to admin_users_path(@store), :notice => notice
  end

  def destroy
    if @store.delete_admin_user(params[:user_id])
      notice = "Administrator deleted."
    else
      notice = "You can't delete the only administrator."
    end

    redirect_to admin_users_path(@store), :notice => notice
  end
end
