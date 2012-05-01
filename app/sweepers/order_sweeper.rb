class OrderSweeper < ActionController::Caching::Sweeper
  observe Order

  def after_save(order)
    expire_caches_for(order)
  end

  def after_destroy(order)
    expire_caches_for(order)
  end

  private

  def expire_caches_for(order)
    store_orders_count = store_orders ? store_orders.count : 0
    page_count = (store_orders_count/ITEMS_PER_PAGE) + 1
    expire_fragment "#{order.store.to_param}_admin_orders_"
    (2..page_count).each { |page_number|
      expire_fragment "#{order.store.to_param}_admin_orders_#{page_number}"
    }
  end
end