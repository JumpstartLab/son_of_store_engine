class Admin::StoresController < ApplicationController
  before_filter :require_login
  before_filter :is_super_admin
  #before_filter :is_store_admin?, only: [ :show ]
  #before_filter :is_super_admin

  def index
    @stores = Store.all
  end

  def update
    @store = Store.find_by_id(params[:id])
    @store.update_attributes(params[:store])
    if params[:store][:approved] == "true"
      Resque.enqueue(Emailer, "store", "store_approval_confirmation", @store.owner.id, @store.id)
    elsif params[:store][:approved] == "false"
      Resque.enqueue(Emailer, "store", "store_rejection_confirmation", @store.owner.id, @store.id)
    end
    redirect_to :back,
      :notice => "#{@store.name} was updated!"
  end

  def show
    @store = Store.find_by_url_name(params[:id])
  end

  private

  def is_super_admin
    redirect_to_last_page("Nice try, jerk.") unless
      current_user.admin
  end

end
