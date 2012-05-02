require 'bigdecimal'

class StatsController < ApplicationController
  include MemoryCache

  def revenue_over_time
    render :json => retrieve("#{current_store.slug}:revenue_over_time")
  end

  def category_revenue
    render :json => retrieve("#{current_store.slug}:category_revenue")
  end

  def top_ten_user_revenue
    render :json => retrieve("#{current_store.slug}:top_ten_user_revenue")
  end
end
