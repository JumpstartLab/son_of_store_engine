module ExtraCategoryMethods
  def lookup_category
    @category = store_categories.where(id: params[:id]).first
    @products = @category.products
  end

  def store_categories
    Category.where(store_id: @current_store.id)
  end

  def lookup_category
    @category = store_categories.where(id: params[:id]).first
    @products = @category.products
  end

  def store_categories
    Category.where(store_id: @current_store.id)
  end

  def confirm_has_store_admin_access
    redirect_to root_path unless current_user.is_admin_of(@current_store)
  end
end
