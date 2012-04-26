class Admin::StoresController < ApplicationController
  before_filter :require_login
  before_filter :is_admin?
  #before_filter :is_super_admin

  def index
    @stores = Store.all
  end

  def update
    @store = Store.find_by_id(params[:id])
    @store.update_attributes(params[:store])
    if params[:store][:approved => true]
      StoreMailer.store_approval_confirmation(@store).deliver
    end
    redirect_to :back, 
      :notice => "#{@store.name} was updated!"
  end

end