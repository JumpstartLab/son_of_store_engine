module Admin::StoresHelper

  def store_actions_by_status(store)
    if store.approved.nil?
      approve_link(store.url_name) + " | " + decline_link(store.url_name)
    elsif store.approved && store.enabled
      disable_link(store.url_name)
    elsif store.approved && store.disabled
      enable_link(store.url_name)
    end
  end

  def approve_link(url_name)
    link_to("Approve this store",
        admin_store_path(id: url_name, :store => {approved: true, enabled: true}), method: :put)
  end

  def decline_link(url_name)
    link_to("Decline this store",
        admin_store_path(id: url_name, :store => {approved: false}), method: :put)
  end

  def disable_link(url_name)
    link_to("Disable this store",
        admin_store_path(id: url_name, :store => {enabled: false}), method: :put)
  end

  def enable_link(url_name)
    link_to("Enable this store",
        admin_store_path(id: url_name, :store => {enabled: true}), method: :put)
  end

end
