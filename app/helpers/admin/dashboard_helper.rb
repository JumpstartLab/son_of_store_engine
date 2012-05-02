module Admin::DashboardHelper

  def orders_count_by_status(status)
    OrderStatus.find_all_by_status(status).count
  end

  def store_status
    if store.pending?
      "Pending approval"
    elsif store.approved && store.enabled
      "running live baby!"
    elsif store.approved && store.disabled
      "down for maintenance"
    elsif store.declined
      "declined. Go leave us alone"
    end
  end

end
