module Admin::StoresHelper

  def store_actions_by_status(store)
    if store.approved.nil?
      approve_link(store.id) + " | " + decline_link(store.id)
    elsif store.approved

    end
  end

  def approve_link(id)
    link_to("Approve this store",
        admin_store_path(id: id, :store => {approved: true, enabled: true}), method: :put)
  end

  def decline_link(id)
    link_to("Decline this store",
        admin_store_path(id: id, :store => {approved: false}), method: :put)
  end

  def cancelled_link(id)
    link_to("Mark as cancelled",
        admin_order_status_path(order_id: id, new_status: 'cancelled'),
        method: :put)
  end

end
