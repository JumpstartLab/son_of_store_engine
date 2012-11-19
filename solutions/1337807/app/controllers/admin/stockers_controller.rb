# Admins have direct access to administering or creating new stockers
class Admin::StockersController < Admin::ApplicationController
  load_and_authorize_resource :store

  def create
    if @store.add_stocker_from_form(params[:email])
      notice = "New stocker successfully added."
    else
      @store.invite_new_stocker(params[:email])
      notice = "User with email '#{params[:email]}' does not exist."
    end
    redirect_to admin_users_path(@store), :notice => notice
  end

  def destroy
    if @store.delete_stocker_user(params[:user_id])
      notice = "Stocker deleted."
    end
    redirect_to admin_users_path(@store), :notice => notice if notice
  end
end
