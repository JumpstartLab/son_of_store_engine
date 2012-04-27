module SessionHelpers
  private
  def successful_login_path
    if current_store && params[:checkout]
      new_order_path(current_store.slug)
    elsif current_store
      store_path(current_store.slug)
    else
      root_path
    end
  end

  def successful_logout_path
    if current_store
      store_path(current_store.slug)
    else
      root_url
    end
  end

  def transfer_cart_to_user(cart, user)
    return if cart.nil?

    if cart.has_products?
      existing_cart = user.carts.where(:store_id => current_store.id).first
      existing_cart.destroy if existing_cart
      user.carts << cart
    else
      cart.destroy
    end
  end
end