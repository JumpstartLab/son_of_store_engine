class StoreDashboardStatsJob
  extend MemoryCache 
  @queue = :store_stats

  def self.perform
    Store.all.each do |store|
      StoreDashboardStatsJob.revenue_over_time(store)
      StoreDashboardStatsJob.category_revenue(store)
      StoreDashboardStatsJob.top_ten_user_revenue(store)
    end
  end

  def self.revenue_over_time(store)
    day_to_revenue = OrderItem.joins(:order)
      .where("orders.store_id = #{store.id}")
      .group("date(orders.created_at)").order("date_orders_created_at").sum("quantity * unit_price")

    result = day_to_revenue.collect do |date, revenue| 
      [Time.parse(date).to_i * 1000, revenue.to_i]
    end

    key = "#{store.slug}:revenue_over_time"
    store(key, result.to_json)
  end

  def self.category_revenue(store)
    result = OrderItem.joins(:order => :store).joins(:product => :product_categories).
      where("orders.store_id = #{store.id}").group("category_id").sum("quantity * price")

    total_revenue = result.values.inject(0) do |sum, revenue| 
      sum += revenue.to_f 
    end

    category_name_to_revenue = []
    result.each do |category, revenue|
      category = Category.find(category)
      percentage = (revenue.to_f / total_revenue.to_f) * 100
      category_name_to_revenue << ["#{category.title} ($#{revenue})", percentage.to_f]
    end

    key = "#{store.slug}:category_revenue"
    store(key, category_name_to_revenue.to_json)
  end

  def self.top_ten_user_revenue(store)
    user_to_revenue = OrderItem.joins(:order)
    .where("orders.store_id = #{store.id}")
    .group("orders.user_id").order("sum_quantity_all_unit_price DESC")
    .limit(10).sum("quantity * unit_price")
    result = user_to_revenue.collect do |user_id, revenue| 
      {:name => User.find(user_id).full_name, :data => [revenue.to_i] }
    end

    key = "#{store.slug}:top_ten_user_revenue"
    store(key, result.to_json)
  end
end
