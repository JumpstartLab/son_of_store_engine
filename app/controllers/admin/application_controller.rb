# You should have a very good reason to add code to this file
class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticated_store_user!

  def default_url_options(options={})
    { :slug => params[:slug] }
  end

  def authenticated_store_user!
    unless can? :manage, @store
      return redirect_to products_path(@store),
        :notice => 'Access denied. This page is for administrators only.'
    end
  end
end
