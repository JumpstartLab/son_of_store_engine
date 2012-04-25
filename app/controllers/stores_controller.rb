class StoresController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  def show
    redirect_to products_path(@store)
  end

  def index
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to products_path(@store)
    else
      render 'new'
    end
  end
end
