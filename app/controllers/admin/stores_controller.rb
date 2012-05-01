class Admin::StoresController < ApplicationController
  before_filter :is_super_admin, only: [ :index ]

  def index
    @stores = Store.all
  end

  def update
    store ? @store = store : @store = Store.find_by_url_name(params[:id])
    @store.update_attributes(params[:store])
    if params[:store][:approved] == "true"
      Resque.enqueue(Emailer, "store", "store_approval_confirmation", @store.owner.id, @store.id)
    elsif params[:store][:approved] == "false"
      Resque.enqueue(Emailer, "store", "store_rejection_confirmation", @store.owner.id, @store.id)
    end
    admin_dashboard_url(:subdomain => store.url_name)
    super_dash_or_admin_dash(params)
    # redirect_to admin_dashboard_url(:subdomain => @store.url_name),
    #   :notice => "#{@store.name} was updated!"
    # redirect_to :back,
    #   :notice => "#{ @store.name } was updated!"
  end

  def edit
    @store = store
  end

  private

  def super_dash_or_admin_dash(params)
    if params[:store][:enabled]
      redirect_to :back,
        :notice => "#{ @store.name } was updated!"
    else
      redirect_to admin_dashboard_url(:subdomain => @store.url_name),
        :notice => "#{@store.name} was updated!"
    end
  end

  def is_super_admin
    redirect_to_last_page("NOT A SUPER ADMIN.") unless
      current_user.admin
  end

end
