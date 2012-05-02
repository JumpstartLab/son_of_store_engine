module ApplicationHelper

  def get_cart_count
    current_cart ? current_cart.cart_count : 0
  end

  def store_name
    store ? store.name : "Chez Pierre"
  end

  def super_admin_link
    if current_user.admin
      link_to("SUPER ADMIN DASHBOARD", 
        admin_stores_url(subdomain: false), class: "btn btn-primary")
    end
  end

  def super_admin_note
    if current_user.admin
      "Allo Admin Super!"
    end
  end

  def store_button(store)
    if store.stockers.include?(current_user)
      link_to "Stock products!", 
        admin_products_url(subdomain: store.url_name),
        class: "pull-right btn btn-success"
    elsif store.admins.include?(current_user)
      link_to "Don't hate! Administrate!", 
        admin_dashboard_url(subdomain: store.url_name),
        class: "pull-right btn btn-danger"
    end
  end
end