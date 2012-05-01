class OrderSweeper < ActionController::Caching::Sweeper
  observe Order

  def sweep(order)
    expire_fragment("orders_index_page")
    expire_fragment("admin_orders_index_page")
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end