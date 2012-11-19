class OrderSweeper < ActionController::Caching::Sweeper
  observe Order

  def sweep(order)
    expire_fragment("order_with_id#{order.id}")
    expire_fragment("admin_order_with_id#{order.id}")
  end
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end