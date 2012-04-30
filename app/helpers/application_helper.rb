module ApplicationHelper

  def get_cart_count
    current_cart ? current_cart.cart_count : 0
  end

  def store_slug
    current_store && current_store.slug.downcase || params[:slug]
  end

end
