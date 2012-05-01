class Store::Admin::RolesController < Store::Admin::BaseController
  
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
end