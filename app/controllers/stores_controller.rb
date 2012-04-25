class StoresController < ApplicationController
  def show
    redirect_to products_path(@store)
  end

  def index
    render :text => "hI!"
  end
end
