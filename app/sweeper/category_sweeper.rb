class CategorySweeper < ActionController::Caching::Sweeper
  observe Category

  def sweep(category)
    expire_fragment("categories_index_page")
    expire_fragment("admin_categories_index_page")
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end