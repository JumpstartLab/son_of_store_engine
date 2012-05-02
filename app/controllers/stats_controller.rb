require 'bigdecimal'

class StatsController < ApplicationController
  def revenue_over_time
    day_to_revenue = OrderItem.joins(:order)
      .where("orders.store_id = #{current_store.id}").order("date_orders_created_at")
      .group("date(orders.created_at)").sum("quantity * unit_price")
    
    result = day_to_revenue.collect do |date, revenue| 
        [Time.parse(date).to_i * 1000, revenue]
    end

    #key = "#{current_store.slug}:revenue_over_time"
    #result = Rails.cache.read(key)
    #if result.nil?
      #total = 0
      #result = Order.limit(600).group(:created_at).collect do |order|
        #total += order.total_price.to_f
        #[order.created_at.to_i * 1000, total]
      #end
      #Rails.cache.write(key, result)
    #end
    render :json => result.to_json
  end

  def category_revenue
    result = OrderItem.joins(:order => :store).joins(:product => :product_categories).
      where("orders.store_id = #{current_store.id}").group("category_id").sum("quantity * price")

    total_revenue = result.values.inject(0) do |sum, revenue| 
      sum += revenue.to_f 
    end

    category_name_to_revenue = []
    result.each do |category, revenue|
      category = Category.find(category)
      percentage = (revenue.to_f / total_revenue.to_f) * 100
      category_name_to_revenue << ["#{category.title} ($#{revenue})", percentage.to_f]
    end

    render :json => category_name_to_revenue.to_json
  end

  def top_ten_user_revenue
    user_to_revenue = OrderItem.joins(:order)
    .where("orders.store_id = #{current_store.id}")
    .group("orders.user_id").order("sum_quantity_all_unit_price DESC")
    .limit(10).sum("quantity * unit_price")
#name: 'John',
			#data: [5, 3, 4, 7, 2]
    result = user_to_revenue.collect do |user_id, revenue| 
      {:name => User.find(user_id).full_name, :data => [revenue] }
    end

    render :json => result.to_json
  end
end
