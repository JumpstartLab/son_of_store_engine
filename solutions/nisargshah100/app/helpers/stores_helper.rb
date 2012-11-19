module StoresHelper
  def create_cart
    unless session[:cart_id]
      session[:cart_id] = Cart.create.id
    end
  end

  def find_store
    if not params[:slug].blank?
      @store = Store.find_by_slug(params[:slug]).first
      validate_store(@store)
    end

    if @store and @store.active?
      session[:return_to_store] = request.fullpath
    end
  end

  def validate_store(store)
    return down_for_maintenance if store and store.disabled?
    not_found unless store && store.active?
  end
end
