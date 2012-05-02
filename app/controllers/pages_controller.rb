class PagesController < ApplicationController
  def index
    if request.subdomain.present?
      redirect_to(request.protocol + request.domain + (request.port.nil? ? '' : ":#{request.port}"))
    end
    @store = Store.find_all_active_stores.page(params[:page])
  end
end
