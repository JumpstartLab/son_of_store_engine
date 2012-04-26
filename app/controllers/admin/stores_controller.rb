class Admin::StoresController < ApplicationController
  before_filter :verify_site_admin

  def index
    @approved_stores  = Store.where(:status => "approved")
    @pending_stores   = Store.where(:status => "pending")
    @disabled_stores  = Store.where(:status => "disabled")
  end

  def update
    @store = Store.find(params[:id])
    @store.update_attributes(params[:store])
    if @store.status == "approved"
      StoreMailer.store_approval_notification(@store).deliver
    elsif @store.status == "declined"
      StoreMailer.store_declined_notification(@store).deliver
    end
    redirect_to :back
  end
end