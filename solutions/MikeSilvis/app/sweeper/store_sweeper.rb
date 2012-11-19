class StoreSweeper < ActionController::Caching::Sweeper
  observe Store

  def sweep(store)
    expire_fragment("admin_store_with_id_#{store.id}")
  end
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end