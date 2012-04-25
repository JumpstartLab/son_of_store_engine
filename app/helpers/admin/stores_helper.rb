module Admin::StoresHelper

  def admin_buttons_for_store(store)
    buttons = [edit_button(store)]
    buttons << enable_button(store) if store.disabled?
    buttons << disable_button(store) if store.enabled?
    buttons << approve_button(store) if store.pending?
    buttons << decline_button(store) if store.pending?
    buttons.join(" | ").html_safe
  end

  def edit_button(store)
    link_to "Edit", edit_admin_store_path(store), method: :put
  end
  def enable_button(store)
    link_to "Enable", enable_admin_store_path(store), method: :put
  end
  def disable_button(store)
    link_to "Disable", disable_admin_store_path(store), method: :put
  end
  def approve_button(store)
    link_to "Approve", approve_admin_store_path(store), method: :put
  end
  def decline_button(store)
    link_to "Decline", decline_admin_store_path(store), method: :put
  end
end
