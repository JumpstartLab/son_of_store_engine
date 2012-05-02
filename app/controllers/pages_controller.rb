class PagesController < ApplicationController
  def index
    if request.subdomain.present?
      redirect_to(request.protocol +
      request.domain +
      (request.port.nil? ? '' : ":#{request.port}"))
    end
    @store = Store.all
  end
end
