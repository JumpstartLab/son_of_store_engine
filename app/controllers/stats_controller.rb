class StatsController < ApplicationController
  def revenue_over_time
    key = "#{current_store.slug}:revenue_over_time"
    result = Rails.cache.read(key)
    if result.nil?
      total = 0
      result = Order.limit(600).group(:created_at).collect do |order|
        total += order.total_price.to_f
        [order.created_at.to_i * 1000, total]
      end
      Rails.cache.write(key, result)
    end
    render :json => result.to_json
  end

  def percent_sales_per_category
    total = 0

    Order.limit()
    #result = Order.limit(600).collect do |order| 
      #total += order.total_price.to_f
      #[order.created_at.to_i * 1000, total]
    #end
    #render :json => result.to_json
  end
end
