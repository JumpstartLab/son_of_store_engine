class Store::Admin::RolesController < Store::Admin::BaseController

  def new
    @user = User.new
    @role = @user.roles.new
  end
  
  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      determine_path_and_assign_role(@user)
    else
      new_user_email = params[:user][:email]
      Resque.enqueue(UserEmailer, "signup_notification", new_user_email)
      redirect_to admin_path(current_store.slug),
        :notice => "That user does not exist, so we sent a signup email to #{new_user_email}."
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.notify_user_of_role_removal

    if @role.destroy
      message = "#{@role.user.name} has been removed as a #{@role.name}. "
      message += "Sent email to #{@role.user.email}"
    end
    flash.notice = message
    redirect_to admin_path(current_store.slug)
  end

  def determine_path_and_assign_role(user)
    if URI(request.referer).path == "/mittenberry/admin/store_stocker/new"
      user.roles << user.roles.create(name: "store_stocker", store: current_store)
      user.save
      # IS THIS CORRECT?
      user.roles.last.notify_user_of_role_addition
    elsif URI(request.referer).path == "/mittenberry/admin/store_admin/new"
      user.roles << user.roles.create(name: "store_admin", store: current_store)
      user.save
      # IS THIS CORRECT?
      user.roles.last.notify_user_of_role_addition
    end
    message = "#{user.name} has been added as a #{user.roles.last.name}. "
    message += "Sent email to #{user.email}"
    flash.notice = message
    redirect_to admin_path(current_store.slug)
  end
end