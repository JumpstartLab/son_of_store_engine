class DashboardController < ApplicationController
  before_filter :validate_store 
  before_filter :user_may_manage, only: :show
  before_filter :ensure_active

  def show
    @order = Order.where("store_id = #{current_store.id}").count
    @product = Product.where("store_id = #{current_store.id}")
      .where(:activity => true).count
    @categories = @store.categories
    @employees = @store.employees
  end

  private
  def validate_store
    @store = current_store
    return redirect_to root_path, 
           alert: "Oops, Store doesn't exist." unless @store
  end

  def ensure_active
    @store = Store.find_by_slug(params[:store_id])
    unless @store && @store.status == "enabled"
      redirect_to root_path, :notice => "Store is not currently approved"
    end
  end

end
