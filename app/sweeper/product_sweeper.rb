class ProductSweeper < ActionController::Caching::Sweeper
  observe Product

  def sweep(product)
    expire_fragment("admin_product_with_id_#{product.id}")
    expire_fragment("product_index_with_id_#{product.id}")
  end
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end