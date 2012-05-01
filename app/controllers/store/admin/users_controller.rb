class Store::Admin::UsersController < Store::Admin::BaseController

  def new
    authorize! :promote_users?, current_store
    @user = current_store.users.new
  end

  def create
    authorize! :promote_users?, current_store
    @user = current_store.users.find_by_email(params[:user][:email])
    if @user
      determine_path_and_assign_role(@user)
    else
      # send email
      redirect_to :back
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to :back, :notice => "#{@user.name} was deleted."
    else
      redirect_to :back, :notice => "Try again."
    end
  end

  def determine_path_and_assign_role(user)
    if URI(request.referer).path == "/mittenberry/admin/store_stocker/new"
      user.roles << user.roles.create(name: "store_stocker", store: current_store)
      user.save
      redirect_to :back
    elsif URI(request.referer).path == "/mittenberry/admin/store_admin/new"
      user.roles << user.roles.create(name: "store_admin", store: current_store)
      user.save
      redirect_to :back
    end
  end

end