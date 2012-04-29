module SessionHelpers
  private
  # XXX THIS LOOKS REALLY SCARY.
  # What's with the slug param?
  # The rest of the site uses store_slug.
  # This param was comming up empty at osme point...
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

  # XXX this needs some lovin'
  def transfer_cart_to_user(cart, user)
    return if cart.nil?

    if cart.has_products?
      existing_cart = user.carts.where(:store_id => cart.store_id).first
      existing_cart.destroy if existing_cart
      user.carts << cart
    else
      cart.destroy
    end
  end
end
