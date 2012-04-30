module SessionHelpers
  private

  def successful_login_path
    if params[:slug].present? && params[:checkout].present?
      new_order_path(params[:slug])
    elsif params[:slug].present?
      store_path(params[:slug])
    else
      root_path
    end
  end

  def successful_logout_path
    if params[:slug]
      store_path(params[:slug])
    else
      root_url
    end
  end

  def transfer_cart_to_user(cart, user)
    return if cart.nil?

    if cart.has_products?
      user.find_cart_by_store_id(cart.store_id).try(:destroy)
      user.carts << cart
    else
      cart.try(:destroy)
    end
  end
end
