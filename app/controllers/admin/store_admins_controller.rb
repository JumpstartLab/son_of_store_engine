class Admin::StoreAdminsController < Admin::ApplicationController
  skip_before_filter :is_admin?
  before_filter :is_store_admin?


  def destroy
    @store_admin = StoreAdmin.scoped.where("user_id = ?",params[:id]).where("store_id = ?", store.id ).first
    @store_admin.destroy
    flash[:message] = "Removed #{@store_admin.user.name} from #{store.name}"
    redirect_to session[:last_page]
  end


  def create
    if admin = User.find_by_email(params[:new_admin_email_address])
      @new_store_admin = StoreAdmin.create(:store_id => store.id, :user_id => admin.id, :stocker => params[:store_admin][:stocker])
      redirect_to admin_dashboard_path
    elsif stocker = User.find_by_email(params[:new_stocker_email_address])
      @new_store_stocker = StoreAdmin.create(:store_id => store.id, :user_id => stocker.id, :stocker => params[:store_admin][:stocker])
      redirect_to admin_dashboard_path
    else
      email = params[:new_admin_email_address] || params[:new_stocker_email_address]
      flash[:message] = "#{email} could not be found in the system, so they have been invited to join the store. Try to add them as an admin after they have created an account."
      StoreAdmin.request_signup(email, store)
      redirect_to session[:last_page]
    end
  end
end
