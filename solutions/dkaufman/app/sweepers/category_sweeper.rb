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
    slug = category.store.to_param
    if slug
      [slug, slug + "_admin"].each do |fragment|
        expire_pages_with_key(category.store, fragment)
      end
    end
  end

  def expire_pages_with_key(set, slug)
    expire_fragment "#{slug}_categories_"
    (2..set.page_count(ITEMS_PER_PAGE)).each do |page_number|
      expire_fragment "#{slug}_categories_#{page_number}"
    end
  end
end
