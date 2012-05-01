class Admin::ApplicationController < ApplicationController
  before_filter :require_login
  before_filter :is_admin?

  def default_url_options(options={})
    { :url_name => params[:url_name] }
  end

end
