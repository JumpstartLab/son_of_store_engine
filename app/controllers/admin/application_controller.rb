# You should have a very good reason to add code to this file
class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?

  def admin?
    error = "Access denied. This page is for administrators only."
    redirect_to :root, :notice => error unless current_user.admin?
  end
end
