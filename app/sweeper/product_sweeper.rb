class ProductSweeper < ActionController::Caching::Sweeper
  observe Product

  def sweep(product)
    expire_fragment("products_index_page")
    expire_fragment("admin_products_index_page")
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end