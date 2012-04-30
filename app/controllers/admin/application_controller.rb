# You should have a very good reason to add code to this file
class Admin::ApplicationController < ApplicationController
  def default_url_options(options={})
    { :slug => params[:slug] }
  end
end
