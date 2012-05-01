class StoreSweeper < ActionController::Caching::Sweeper
  observe Store

  def sweep(store)
    expire_fragment("admin_stores_index_page")
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end