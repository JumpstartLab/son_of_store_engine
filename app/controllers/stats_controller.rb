require 'bigdecimal'

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

  def category_revenue
    result = OrderItem.joins(:order => :store).joins(:product => :product_categories).
      where("orders.store_id = #{current_store.id}").group("category_id").sum("quantity * price")

    total_revenue = result.values.inject(0) do |sum, revenue| 
      sum += revenue 
    end

    category_name_to_revenue = []
    result.each do |category, revenue|
      category = Category.find(category)
      percentage = (revenue.to_f / total_revenue.to_f) * 100
      category_name_to_revenue << ["#{category.title} ($#{revenue})", percentage.to_f]
    end

    render :json => category_name_to_revenue.to_json
  end
end
