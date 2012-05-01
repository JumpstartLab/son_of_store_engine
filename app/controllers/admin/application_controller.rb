class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :is_store_admin

  def default_url_options(options={})
    { :url_name => params[:url_name] }
  end

  def is_store_admin
    redirect_to_last_page unless 
      current_user.admin || store.admins.include?(current_user)
  end

  def is_stocker_or_admin
    redirect_to store_path(subdomain: store.url_name),
      notice: "Zut! You don't seem to have the proper permissions!" unless
      store.store_admins.include?(current_user) || current_user.admin
  end

end
