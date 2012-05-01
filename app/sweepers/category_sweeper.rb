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
    expire_fragment("#{category.store.to_param}_admin_categories")
  end
end