module FindByStatusExtension
  def find_by_status(status_filter=nil)
    if status_filter.nil?
      self.order("created_at DESC")
    else
      self.joins(:order_status).
        where('order_statuses.status = ?', status_filter).order("created_at DESC")
    end
  end
end