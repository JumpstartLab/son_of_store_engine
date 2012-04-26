module Admin::StoresHelper

  def store_actions_by_status(store)
    if store.approved.nil?
      approve_link(store.id) + " | " + decline_link(store.id)
    elsif store.approved && store.enabled
      disable_link(store.id)
    elsif store.approved && store.disabled
      enable_link(store.id)
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

  def disable_link(id)
    link_to("Disable this store",
        admin_store_path(id: id, :store => {enabled: false}), method: :put)
  end

  def enable_link(id)
    link_to("Enable this store",
        admin_store_path(id: id, :store => {enabled: true}), method: :put)
  end

end
