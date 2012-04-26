class Admin::StoresController < ApplicationController
  def show
    @store = Store.find_by_domain(params[:id])
  end

  def index
    @stores = Store.all
  end
end