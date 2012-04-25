class StoresController < ApplicationController
  before_filter :authorize

  def new
    @store = Store.new
  end

  def create
    @store = Store.create(params[:store].merge(owner_id: current_user.id))
    if @store.save
      return redirect_to profile_path, notice: "Store Created!"
    else
      flash[:error] = @store.errors.full_messages.join(", ")
      return redirect_to :back
    end
  end
end
