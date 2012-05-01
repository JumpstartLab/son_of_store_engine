module ApplicationHelper

  def get_cart_count
    current_cart ? current_cart.cart_count : 0
  end

  def store_slug
    current_store && current_store.slug.downcase || params[:slug]
  end

  def orders_count_by_status(status)
    OrderStatus.find_all_by_status(status).count
  end

  def order_actions_by_status(order)
    case order.status
    when "paid"
      shipped_link(order.id) + " | " + cancelled_link(order.id)
    when "shipped"
      returned_link(order.id)
    when "pending"
      cancelled_link(order.id)
    when "returned"
      "Returned"
    when "cancelled"
      "Cancelled."
    end
  end

  def timestamp(order)
    case order.status
    when 'shipped', 'cancelled'
      "#{order.status.capitalize} on #{order.updated_at.to_s(:pretty)}"
    end
  end

  def shipped_link(id)
    link_to("Mark as shipped",
        store_admin_order_status_path(order_id: id, new_status: 'shipped'),
        method: :put)
  end

  def returned_link(id)
    link_to("Mark as returned",
        store_admin_order_status_path(order_id: id, new_status: 'returned'),
        method: :put)
  end

  def cancelled_link(id)
    link_to("Mark as cancelled",
        store_admin_order_status_path(order_id: id, new_status: 'cancelled'),
        method: :put)
  end

def store_actions_by_status(store)
    case store.status
      when "pending"
        approve_link(store) + " | " + decline_link(store)
      when "approved"
        disable_link(store)
      when "disabled"
        enable_link(store)
      when "enabled"
        disable_link(store)
    end
  end

  def approve_link(store)
    link_to "Approve",
    admin_store_path(store.id, :store => { :status => "approved" }), :method => :put, :id => "#{store.slug}-approve"
  end

  def decline_link(store)
    link_to "Decline",
    admin_store_path(store.id, :store => { :status => "declined" }), :method => :put, :id => "#{store.slug}-decline"
  end

  def enable_link(store)
    link_to "Enable",
    admin_store_path(store.id, :store => { :status => "approved" }), :method => :put, :id => "#{store.slug}-approve"
  end

  def disable_link(store)
    link_to "Disable",
    admin_store_path(store.id, :store => { :status => "disabled" }), :method => :put, :id => "#{store.slug}-disable"
  end

end
