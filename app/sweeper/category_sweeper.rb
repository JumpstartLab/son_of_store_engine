class CategorySweeper < ActionController::Caching::Sweeper
  observe Category

  def sweep(category)
    expire_fragment("category_with_id#{category.id}")
    expire_fragment("admin_category_with_id#{category.id}")
  end
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end