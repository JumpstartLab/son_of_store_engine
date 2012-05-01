module ExtraCategoryMethods
  include ExtraProductMethods
  def lookup_category
    @category = store_categories.where(id: params[:id]).first
  end

  def lookup_products
    @products = active_store_products.joins(:categories).where("category_id = #{@category.id}").page(params[:page]).per(ITEMS_PER_PAGE)
  end

  def store_categories
    Category.where(store_id: @current_store.id)
  end

  def confirm_has_store_admin_access
    redirect_to root_path unless current_user.is_admin_of(@current_store)
  end
end
