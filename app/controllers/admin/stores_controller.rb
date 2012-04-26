class Admin::StoresController < ApplicationController

  def index
    @approved_stores  = Store.where(:status => "approved")
    @pending_stores   = Store.where(:status => "pending")
    @disabled_stores  = Store.where(:status => "disabled")
  end

  def update
    Store.find(params[:id]).update_attributes(params[:store])
    redirect_to :back
  end
end