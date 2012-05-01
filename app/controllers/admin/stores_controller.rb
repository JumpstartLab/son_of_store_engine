class Admin::StoresController < Admin::BaseController

  def index
    @stores = Store.where("status = 'approved'
      OR status = 'disabled'
      OR status = 'pending'")
    authorize! :manage, @stores
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    @store.update_status(params[:store])
    if @store.save
      @store.notify_store_admin_of_status
      message = "Store has been #{@store.status}."
      message += " Sent email to #{@store.users.first.email}"
    else
      message = "There has been an error in updating this store's status."
    end
    flash.notice = message
    redirect_to admin_stores_path
  end

  def show
    @store = Store.find(params[:id])
  end

end
