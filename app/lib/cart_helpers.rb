module CartHelpers
  def find_cart
    current_user ? find_cart_for_user : find_cart_for_guest
  end

  def find_cart_for_user
    current_user.cart = Cart.create if current_user.cart.nil?
    merge_carts(session[:cart_id]) if !session[:cart_id].blank?
    @cart = current_user.cart
  end

  def find_cart_for_guest
    if session[:cart_id].blank?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    else
      @cart = Cart.find(session[:cart_id])
    end
  end

  def merge_carts(old_cart_id)
    current_user.cart.merge(old_cart_id)
    destroy_cart
  end

  def destroy_cart
    Cart.find(session[:cart_id]).destroy
    session[:cart_id] = nil
  end

  def verify_user
    @cart.add_user(current_user)
  end
end