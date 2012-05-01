module SessionHelpers
  private

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
