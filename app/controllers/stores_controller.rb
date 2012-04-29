class StoresController < ApplicationController
  before_filter :authorize, except: [:index, :show]

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store].merge(owner_id: current_user.id))
    if @store.save
      return redirect_to profile_path, notice: "Store Created!"
    else
      flash[:error] = @store.errors.full_messages.join(", ")
      render :new
    end
  end

  def index
    @stores = Store.where status: "enabled"
  end

  def show
    return redirect_to store_products_path(current_store)
  end

  def edit
    @store = Store.find_by_slug(params[:id])
    return redirect_to @store unless current_user.may_manage?(@store)
  end


end
