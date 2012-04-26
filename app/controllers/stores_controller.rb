class StoresController < ApplicationController
  before_filter :authorize, except: "index"

  def new
    @store = Store.new
  end

  def create
    current_store = Store.create(params[:store].merge(owner_id: current_user.id))
    if current_store.save
      return redirect_to profile_path, notice: "Store Created!"
    else
      flash[:error] = current_store.errors.full_messages.join(", ")
      return redirect_to :back
    end
  end

  def index
    @stores = Store.where status: "enabled"
  end
end
