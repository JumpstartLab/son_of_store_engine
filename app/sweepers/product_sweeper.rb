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
    slug = product.store.to_param
    [slug, slug + "_admin"].each do |fragment|
      expire_pages_with_key(category, fragment)
    end
  end

  def expire_category_caches_for(product)
    product.categories.each do |category|
      slug = category.store.to_param 
      ["_category", "_admin_category"].each do |fragment|
        expire_pages_with_key(category, slug + fragment)
      end
    end
  end

  def expire_pages_with_key(set, slug)
    expire_fragment "#{slug}_products_"
    (2..set.page_count(ITEMS_PER_PAGE)).each do |page_number|
      expire_fragment "#{slug}_products_#{page_number}"
    end
  end
end
