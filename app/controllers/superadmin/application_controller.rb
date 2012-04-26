# You should have a very good reason to add code to this file
class Superadmin::ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :authenticate_super_user!

  def authenticate_super_user!
    unless can? :manage, :all
      return redirect_to root_url,
        :notice => 'Access denied. This page is for administrators only.'
    end
  end
end
