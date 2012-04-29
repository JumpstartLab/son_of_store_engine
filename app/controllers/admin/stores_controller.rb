class Admin::StoresController < ApplicationController
  before_filter :verify_site_admin
  skip_before_filter :verify_store_status

  def index
    @approved_stores  = Store.where(:status => "approved")
    @pending_stores   = Store.where(:status => "pending")
    @disabled_stores  = Store.where(:status => "disabled")
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.where(slug: params[:store_slug]).first
    @store.update_attributes(params[:store])
    if params[:store][:status] == "approved"
      # XXX This makes me sad inside...
      message = "Store has been approved."
      if @store.users.first
        message += " Sent email to #{@store.users.first.email}"
        StoreMailer.store_declined_notification(@store).deliver
      end

      flash.notice = message
    elsif params[:store][:status] == "declined"
      message = "Store has been declined."
      if @store.users.first
        message += " Sent email to #{@store.users.first.email}"
        StoreMailer.store_declined_notification(@store).deliver
      end

      flash.notice = message
    end

    redirect_to :back, :notice => "#{@store.name} has been updated."
  end

  def show
    @store = Store.find(params[:id])
  end

end