class StoresController < ApplicationController
  def show
  end

  def index
    @stores = Store.all
    render :layout => false
  end
end
