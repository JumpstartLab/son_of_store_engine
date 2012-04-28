class Admin::StoresController < ApplicationController
  before_filter :verify_site_admin

  def index
    @approved_stores  = Store.where(:status => "approved")
    @pending_stores   = Store.where(:status => "pending")
    @disabled_stores  = Store.where(:status => "disabled")
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    raise "IT'S WORKING"
    @store = Store.find(params[:id])
    @store.update_attributes(params[:store])
    if @store.status == "approved"
      flash[:notice] = "Store has been approved. Sent email to #{@store.users.first.email}"
      StoreMailer.store_approval_notification(@store).deliver
    elsif @store.status == "declined"
      flash[:notice] = "Store has been declined. Sent email to #{@store.users.first.email}"
      StoreMailer.store_declined_notification(@store).deliver
    else
      redirect_to :back
    end
  end

  def show
    @store = Store.find(params[:id])
  end

end