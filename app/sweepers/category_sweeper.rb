class CategorySweeper < ActionController::Caching::Sweeper
  observe Category

  def after_save(category)
    expire_caches_for(category)
  end

  def after_destroy(category)
    expire_caches_for(category)
  end

  private

  def expire_caches_for(category)
    store_categories_count = store_categories ? store_categories.count : 0
    page_count = (store_categories_count/ITEMS_PER_PAGE) + 1
    expire_fragment "#{order.store.to_param}_admin_categories_"
    (2..page_count).each { |page_number|
      expire_fragment "#{order.store.to_param}_admin_categories_#{page_number}"
    }
  end
end