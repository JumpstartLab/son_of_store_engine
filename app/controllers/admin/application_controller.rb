class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :is_admin?

  def default_url_options(options={})
    { :url_name => params[:url_name] }
  end

  def is_stocker_or_admin?
    redirect_to store_path(subdomain: store.url_name) unless
      store.users.include?(current_user) || current_user.admin
  end

end
