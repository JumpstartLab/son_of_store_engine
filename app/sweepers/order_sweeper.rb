class OrderSweeper < ActionController::Caching::Sweeper
  observe Order

  def after_save(order)
    expire_caches_for(order)
  end

  def after_destroy(order)
    expire_caches_for(order)
  end

  private

  def expire_caches_for(order)
    slug = order.store.to_param
    if slug
      [slug, slug + "_admin"].each do |fragment|
        expire_pages_with_key(order.store, fragment)
      end
    end
  end

  def expire_pages_with_key(set, slug)
    expire_fragment "#{slug}_orders_"
    (2..set.page_count(ITEMS_PER_PAGE)).each do |page_number|
      expire_fragment "#{slug}_orders_#{page_number}"
    end
  end
end
