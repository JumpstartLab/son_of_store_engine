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
    expire_fragment("#{order.store.to_param}_admin_orders")
  end
end