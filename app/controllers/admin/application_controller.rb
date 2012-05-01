class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :is_store_admin

  def default_url_options(options={})
    { :url_name => params[:url_name] }
  end

  def is_store_admin
    redirect_to_last_page("You shall not pass.") unless 
      current_user.admin || store.admins.include?(current_user)
  end

end
