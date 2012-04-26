class StoresController < ApplicationController
  before_filter :require_login
  before_filter :lookup_store, :only => [:show, :edit, :update]
  before_filter :verify_user_role, :only => [:edit, :update, :show]

  def new
    @store = Store.new    
  end
  def show

  end
  def edit

  end
  def create
    @store = Store.new(params[:store])
    @store.users << current_user
    if @store.save
      redirect_to store_path(@store), notice: 'Store was successfully created.'
    else
      render action: "new"
    end    
  end
  def update
    if @store.update_attributes(params[:store])
      redirect_to store_path(@store), notice: 'Store was successfully updated.'
    else
      render action: "edit"
    end    
  end

private

  def lookup_store
    @store = Store.find(params[:id])
  end

  def verify_user_role
    @sr = @store.store_roles.find_by_user_id(current_user.id)
    if @sr.nil?
      flash[:alert] = "You do not have permission"
      redirect_to root_url
    end
  end

end