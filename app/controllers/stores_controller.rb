class StoresController < ApplicationController
  before_filter :require_login, only: [ :new, :create ]
  before_filter :is_store_approved?, only: [ :show ]

  def index
    @stores = Store.where(:approved => true).paginate(:page => params[:page])
  end

  def new
    @new_store = Store.new
  end

  def show
    redirect_to products_path
  end

  def create
    @new_store = Store.create(params[:store])
    if @new_store.save
        redirect_to admin_dashboard_url(:subdomain => @new_store.url_name),
        :notice => "Sweet! #{@new_store.name} was created and is currently pending approval!"
    else
      @new_store.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'new'
    end
  end

end
