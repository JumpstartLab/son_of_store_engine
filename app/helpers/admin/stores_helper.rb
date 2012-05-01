module Admin::StoresHelper

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