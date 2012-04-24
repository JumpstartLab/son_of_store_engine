module CartHelpers
  def find_cart
    current_user ? find_cart_for_user : find_cart_for_guest
  end

  def find_cart_for_user
    current_user.cart ||= Cart.create
    merge_carts(cookies[:cart_id]) unless cookies[:cart_id].blank?
    @cart = current_user.cart
  end

  def find_cart_for_guest
    if cookies[:cart_id].blank?
      @cart = Cart.create
      cookies[:cart_id] = @cart.id
    else
      @cart = Cart.find(cookies[:cart_id])
    end
  end

  def merge_carts(old_cart_id)
    current_user.cart.merge(old_cart_id)
    destroy_cart
  end

  def destroy_cart
    Cart.find(cookies[:cart_id]).destroy
    clear_cart_from_session
  end

  def clear_cart_from_session
    cookies[:cart_id] = nil
  end

  def verify_user
    @cart.add_user(current_user)
  end
end