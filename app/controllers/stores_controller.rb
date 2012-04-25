class StoresController < ApplicationController
  before_filter :authorize

  def new
    @store = Store.new
  end

  def create
    @store = Store.create(params[:store].merge(owner_id: current_user.id))
    return redirect_to profile_path, notice: "Store Created!"
  end
end
