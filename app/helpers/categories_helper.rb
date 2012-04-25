module CategoriesHelper
  def store_categories
    Category.where(store_id: @current_store.id)
  end
end
