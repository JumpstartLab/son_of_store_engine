# You should have a very good reason to add code to this file
class Superadmin::ApplicationController < ApplicationController
  before_filter :authenticate_superadmin!

  def authenticate_superadmin!
    unless can? :manage, :stores
      flash[:notice] = 'You are not authorized to access this page.'
      redirect_to root_url
    end
  end
end
