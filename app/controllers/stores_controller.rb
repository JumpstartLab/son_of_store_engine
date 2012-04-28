class StoresController < ApplicationController
  before_filter :require_login, only: [ :new, :create ]
  before_filter :is_store_approved?, only: [ :show ]
  #before_filter :not_found, only: [ :show ]

  def index
    @stores = Store.where(:approved => true)
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
      redirect_to user_path(current_user),
        :notice => "Sweet! #{@new_store.name} was created and is currently pending approval!"
    else
      @new_store.errors.full_messages.each do |msg|
        flash.now[:error] = msg
      end
      render 'new'
    end
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Store not found.')
  end

  def is_store_approved?
    not_found unless store.approved? && store.enabled?
  end

end
