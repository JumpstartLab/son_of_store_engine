class Admin::StoreAdminsController < Admin::ApplicationController
  def destroy
    @store_admin = StoreAdmin.scoped.where("user_id = ?",params[:id]).where("store_id = ?", store.id ).first
    @store_admin.destroy
    flash[:message] = "Removed #{@store_admin.user.name} from #{store.name}"
    redirect_to session[:last_page]
  end


  def create
    if admin = User.find_by_email(params[:new_admin_email_address])
      store.add_admin(admin)
      Resque.enqueue(Emailer, "admin", "new_admin_notification", params[:new_admin_email_address], store.id)
      redirect_to admin_dashboard_path
    else
      flash[:message] = "#{params[:new_admin_email_address]} could not be found in the system, so they have been invited to join the store. Try to add them as an admin after they have created an account."
      Resque.enqueue(Emailer, "admin", "request_signup", params[:new_admin_email_address], store.id)
      redirect_to session[:last_page]
    end
  end
end
