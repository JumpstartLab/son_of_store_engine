class PagesController < ApplicationController
  def index
    @store = Store.all
  end
end
