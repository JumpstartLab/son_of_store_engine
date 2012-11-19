module ApplicationHelper
  def display_order_special_url(order)
    orders_lookup_url(sid: order.special_url)
  end
end
