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
      #send email
      redirect_to admin_path(current_store.slug),
        :notice => "That user does not exist, so we sent them a signup email."
    end
  end

  def determine_path_and_assign_role(user)
    if URI(request.referer).path == "/mittenberry/admin/store_stocker/new"
      user.roles << user.roles.create(name: "store_stocker", store: current_store)
      user.save
      redirect_to admin_path(current_store.slug), :notice => "#{user.name} is now a store stocker."
    elsif URI(request.referer).path == "/mittenberry/admin/store_admin/new"
      user.roles << user.roles.create(name: "store_admin", store: current_store)
      user.save
      redirect_to admin_path(current_store.slug), :notice => "#{user.name} is now a store admin."
    end
  end
end