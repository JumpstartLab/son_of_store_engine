module ExtraProductMethods

  def lookup_product
    @product = store_products.where(id: params[:id]).first
  end

  def store_products
    Product.where(store_id: @current_store.id)
  end

  def store_category_products(category_id)
    @products = Product.by_category_id
  end

  def confirm_has_store_admin_or_stocker_access
    unless current_user.is_admin_of(@current_store) ||
      current_user.is_stocker_of(@current_store)
      redirect_to root_path
    end
  end

  def active_store_products
    Product.active.where(store_id: @current_store.id)
  end

  def store_enabled
    if !@current_store || !@current_store.approved?
      render "errors/404", :status => 404, :domain => nil
    elsif @current_store.approved? && !@current_store.enabled
      notice = "This site is currently down for maintenance"
      redirect_to root_path, notice: notice
    end
  end
end
