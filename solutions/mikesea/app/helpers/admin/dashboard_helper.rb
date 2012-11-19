module Admin::DashboardHelper

  def orders_count_by_status(status)
    OrderStatus.find_all_by_status(status).count
  end

  def store_status
    if store.pending?
      "pending approval"
    elsif store.approved && store.enabled
      "LIVE!!"
    elsif store.approved && store.disabled
      "down for maintenance"
    elsif store.declined
      "declined. Go away."
    end
  end

end
