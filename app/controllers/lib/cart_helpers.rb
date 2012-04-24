module CartHelpers
  def cart_id
    cookies[:cart_id]
  end

  def cart_id=(input)
    cookies[:cart_id] = input
  end

  def find_cart
    current_user ? find_cart_for_user : find_cart_for_guest
  end

  def find_cart_for_user
    current_user.cart ||= Cart.create
    merge_carts(cart_id) unless cart_id.blank?
    @cart = current_user.cart
  end

  def find_cart_for_guest
    if cart_id.blank?
      @cart = Cart.create
      cart_id=(@cart.id)
    else
      @cart = Cart.find(cart_id)
    end
  end

  def merge_carts(old_cart_id)
    current_user.cart.merge(old_cart_id)
    destroy_cart
  end

  def destroy_cart
    Cart.destroy(cart_id)
    clear_cart_from_session
  end

  def clear_cart_from_session
    cart_id=(nil)
  end

  def verify_user
    @cart.add_user(current_user)
  end
end