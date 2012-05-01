class ProductSweeper < ActionController::Caching::Sweeper
  observe Product

  def after_save(product)
    expire_caches_for(product)
  end

  def after_destroy(product)
    expire_caches_for(product)
  end

  private

  def expire_caches_for(product)
    expire_fragment("#{product.store.to_param}_products")
    expire_fragment("#{product.store.to_param}_admin_products")
  end
end