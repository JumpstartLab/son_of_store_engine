module ApplicationHelper
  def display_order_special_url(order)
    orders_lookup_url(sid: order.special_url)
  end
  
  def admin_view?
    controller_path.split("/").include?("admin") || controller_path.split("/").include?("store_admin")
  end
end
