class Admin::DashboardController < ApplicationController
  before_filter :require_login
  before_filter :is_admin?

  def show
    @orders = current_store.orders.find_by_status(params[:order_status])
    @categories = current_store.categories
  end

end
