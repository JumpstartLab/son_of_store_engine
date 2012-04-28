# Admins have direct access to administering or creating new admins
class Admin::UsersController < Admin::ApplicationController
  def index
    @users = @store.users.all.sort_by { |user| user.name }
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user.nil?
      redirect_to admin_users_path(@store),
      :notice => "Invalid SonOfStoreEngine user"
    else
      @store.users << @user
      redirect_to admin_users_path(@store),
      :notice => "New admin succesfully added"
    end
  end

  def destroy
    StoreUser.find_by_user_id(params[:user_id]).destroy
    notice = "Admin deleted"
    redirect_to admin_users_path(@store), :notice => notice
  end
end
