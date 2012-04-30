# You should have a very good reason to add code to this file
class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_admin!

  def default_url_options(options={})
    { :slug => params[:slug] }
  end

  def authenticate_admin!
    unless can? :manage, @store
      flash[:notice] = 'You are not authorized to access this page.'
      redirect_to products_path(@store)
    end
  end
end
