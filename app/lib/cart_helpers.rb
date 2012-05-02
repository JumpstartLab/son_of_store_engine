module CartHelpers
  def find_cart
    unless request.subdomain.empty?
      current_user ? find_cart_for_user : find_cart_for_guest
    end
  end

  def find_cart_for_user
    current_user.cart = Cart.create if current_user.cart.nil?
    unless session["cart_#{request.subdomain}"].blank?
      merge_carts(session["cart_#{request.subdomain}"])
    end
    @cart = current_user.cart
  end

  def find_cart_for_guest
    if session["cart_#{request.subdomain}"].blank?
      @cart = Cart.create
      session["cart_#{request.subdomain}"] = @cart.id
    else
      @cart = Cart.find(session["cart_#{request.subdomain}"])
    end
  end

  def merge_carts(old_cart_id)
    current_user.cart.merge(old_cart_id)
    destroy_cart
  end

  def destroy_cart
    Cart.find(session["cart_#{request.subdomain}"]).destroy
    session["cart_#{request.subdomain}"] = nil
  end

  def verify_user
    @cart.add_user(current_user) unless request.subdomain.empty?
  end

  def clear_cart_from_session
    session["cart_#{request.subdomain}"] = nil
  end
end