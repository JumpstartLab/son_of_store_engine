class Admin::StoresController < ApplicationController
  authorize_resource :class => false

  def index
    @approved_stores  = Store.where(:status => "approved")
    @pending_stores   = Store.where(:status => "pending")
    @disabled_stores  = Store.where(:status => "disabled")
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
<<<<<<< HEAD
    @store.update_attributes(params[:store])
    if params[:store][:status] == "approved"
      # XXX This makes me sad inside...
      message = "Store has been approved."
      if @store.users.first
        message += " Sent email to #{@store.users.first.email}"
        Resque.enqueue(Emailer, "store_approval_notification", @store.id)
      end

      flash.notice = message
    elsif params[:store][:status] == "declined"
      message = "Store has been declined."
      if @store.users.first
        message += " Sent email to #{@store.users.first.email}"
        # XXX this should probably also use resque?
        StoreMailer.store_declined_notification(@store).deliver
      end

      flash.notice = message
=======
    @store.update_status(params[:store])
    if @store.save
      @store.notify_store_admin_of_status
      message = "Store has been #{@store.status}."
      message += " Sent email to #{@store.users.first.email}"
    else
      message = "There has been an error in updating this store's status."
>>>>>>> 2bbe3c0fa62051c423ae80c0e9c0ce29509c5306
    end
    flash.notice = message
    redirect_to admin_stores_path
  end

  def show
    @store = Store.find(params[:id])
  end

end
