class ProductSweeper < ActionController::Caching::Sweeper
  observe Product

  def after_save(product)
    expire_caches_for(product)
    expire_category_caches_for(product)
  end

  def after_destroy(product)
    expire_caches_for(product)
    expire_category_caches_for(product)
  end

  private

  def expire_caches_for(product)
    store_products_count = store_products ? store_products.count : 0
    page_count = (store_products_count/ITEMS_PER_PAGE) + 1
    expire_fragment "#{product.store.to_param}_products_"
    expire_fragment "#{product.store.to_param}_admin_products_"
    (2..page_count).each do |page_number|
      expire_fragment "#{product.store.to_param}_products_#{page_number}"
      expire_fragment "#{product.store.to_param}_admin_products_#{page_number}"
    end
  end

  def expire_category_caches_for(product)
    category_ids = product.category_ids
    category_ids.each do |category_id|
      store_category_products_count = store_category_products(category_id) ? store_category_products(category_id).count : 0
      page_count = (store_category_products_count/ITEMS_PER_PAGE) + 1
      expire_fragment "#{product.store.to_param}_category_products_"
      expire_fragment "#{product.store.to_param}_admin_category_products_"
      (2..page_count).each do |page_number|
        expire_fragment "#{product.store.to_param}_category_products_#{page_number}"
        expire_fragment "#{product.store.to_param}_admin_category_products_#{page_number}"
      end
    end
  end
end
